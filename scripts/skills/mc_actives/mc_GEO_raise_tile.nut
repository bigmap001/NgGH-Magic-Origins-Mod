this.mc_GEO_raise_tile <- this.inherit("scripts/skills/mc_magic_skill", {
	m = {},
	function create()
	{
		this.mc_magic_skill.create();
		this.m.ID = "actives.mc_raise_tile";
		this.m.Name = "Raise the Terrain";
		this.m.Description = "Command the earth to raise itself up to a certain height. Can not be used in melee. Success chance based on resolve.";
		this.m.Icon = "skills/active_mc_11.png";
		this.m.IconDisabled = "skills/active_mc_11_sw.png";
		this.m.Overlay = "active_mc_11";
		this.m.SoundOnUse = [
			"sounds/enemies/dlc6/sand_golem_death_01.wav",
			"sounds/enemies/dlc6/sand_golem_death_02.wav",
			"sounds/enemies/dlc6/sand_golem_death_03.wav",
			"sounds/enemies/dlc6/sand_golem_death_04.wav"
		];
		this.m.SoundOnHit = this.m.SoundOnUse;
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.UtilityTargeted + 2;
		this.m.IsActive = true;
		this.m.IsTargetingActor = false;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 25;
		this.m.MinRange = 0;
		this.m.MaxRange = 4;
		this.m.MaxRangeBonus = 9;
		this.m.IsRanged = true;
		this.m.IsUtility = true;
		this.m.IsIgnoreBlockTarget = true;
		this.m.IsConsumeConcentrate = false;
	}

	function getDescription()
	{
		return this.skill.getDescription();
	}
	
	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		local toHit = this.getHitchance(null);
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/hitchance.png",
			text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]" + toHit + "%[/color] chance to succeed"
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles on even ground, more if casting downhill"
		});
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Can [color=" + this.Const.UI.Color.PositiveValue + "]Raise[/color] the height level of a tile"
		});

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onVerifyTarget( _originTile, _targetTile )
	{
		local exclude = [
			this.Const.Tactical.TerrainType.Swamp,
			this.Const.Tactical.TerrainType.DeepWater,
			this.Const.Tactical.TerrainType.ShallowWater
		];

		if (exclude.find(_targetTile.Type) != null)
		{
			return false;
		}
		
		return _targetTile.Level < 3;
	}
	
	function onUse( _user, _targetTile )
	{
		local toHit = this.getHitchance(_targetTile.getEntity());
		local rolled = this.Math.rand(1, 100);
		this.Tactical.EventLog.log_newline();

		for( local i = 0; i < this.Const.Tactical.DustParticles.len(); i = ++i )
		{
			this.Tactical.spawnParticleEffect(false, this.Const.Tactical.DustParticles[i].Brushes, _targetTile, this.Const.Tactical.DustParticles[i].Delay, this.Const.Tactical.DustParticles[i].Quantity, this.Const.Tactical.DustParticles[i].LifeTimeQuantity, this.Const.Tactical.DustParticles[i].SpawnRate, this.Const.Tactical.DustParticles[i].Stages);
		}

		if (rolled <= toHit)
		{
			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " commands the earth! (Chance: " + toHit + ", Rolled: " + rolled + ")");
			}

			this.onRaiseTiles(_user, _targetTile);
		}
		else
		{
			if (!_user.isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " fails to commands the earth (Chance: " + toHit + ", Rolled: " + rolled + ")");
			}

			return false;
		}
		
		return true;
	}

	function onRaiseTiles( _user , _targetTile )
	{
		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, _user.getPos());

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local next = _targetTile.getNextTile(i);

				if (next.IsOccupiedByActor)
				{
					if (next.getEntity().hasZoneOfControl())
					{
						next.getEntity().setZoneOfControl(next, false);
					}

					next.removeZoneOfOccupation(next.getEntity().getFaction());
				}
			}
		}

		if (_targetTile.Level < 3)
		{
			_targetTile.Level += 1;
		}

		for( local i = 0; i < 6; i = ++i )
		{
			if (!_targetTile.hasNextTile(i))
			{
			}
			else
			{
				local next = _targetTile.getNextTile(i);

				if (next.IsOccupiedByActor)
				{
					if (next.getEntity().hasZoneOfControl())
					{
						next.getEntity().setZoneOfControl(next, next.getEntity().hasZoneOfControl());
					}

					next.addZoneOfOccupation(next.getEntity().getFaction());
				}
			}
		}

		if (this.Tactical.getCamera().Level < 3)
		{
			this.Tactical.getCamera().Level += 1;
		}
	}

	function getHitFactors( _targetTile )
	{
		local ret = [];
		if (targetEntity.IsOccupiedByActor)
		{
			ret.push({
				icon = "ui/tooltips/positive.png",
				text = "Is occupied by an entity"
			});
		}
		return ret
	}

	function getHitchance( _targetEntity )
	{
		local toHit = this.getMagicPower(this.getContainer().getActor().getCurrentProperties());
		if (_targetEntity != null) toHit -= 15;
		return this.Math.max(5, this.Math.min(95, toHit));
	}

});

