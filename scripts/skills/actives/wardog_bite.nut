this.wardog_bite <- this.inherit("scripts/skills/skill", {
	m = {
		IsRestrained = false,
		IsSpent = false
	},
	function setRestrained( _f )
	{
		this.m.IsRestrained = _f;
	}
	
	function create()
	{
		this.m.ID = "actives.wardog_bite";
		this.m.Name = "Wardog Bite";
		this.m.Description = "Ripping off your enemy face with your powerful dog jaw. Do poorly against armor.";
		this.m.KilledString = "Mangled";
		this.m.Icon = "skills/active_84.png";
		this.m.IconDisabled = "skills/active_84_sw.png";
		this.m.Overlay = "active_84";
		this.m.SoundOnUse = [
			"sounds/enemies/wardog_bite_00.wav",
			"sounds/enemies/wardog_bite_01.wav",
			"sounds/enemies/wardog_bite_02.wav",
			"sounds/enemies/wardog_bite_03.wav",
			"sounds/enemies/wardog_bite_04.wav",
			"sounds/enemies/wardog_bite_05.wav",
			"sounds/enemies/wardog_bite_06.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted + 5;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsUsingActorPitch = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.DirectDamageMult = 0.1;
		this.m.ActionPointCost = 5;
		this.m.FatigueCost = 10;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
	}

	function isIgnoredAsAOO()
	{
		if (!this.m.IsRestrained)
		{
			return this.m.IsIgnoredAsAOO;
		}

		return !this.getContainer().getActor().isArmedWithRangedWeapon()
	}
	
	function getTooltip()
	{
		return this.getDefaultTooltip();
	}

	function isUsable()
	{
		return this.skill.isUsable() && !this.m.IsSpent;
	}

	function onUse( _user, _targetTile )
	{
		if (this.m.IsRestrained)
		{
			this.m.IsSpent = true;
		}

		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}
	
	function canDoubleGrip()
	{
		local main = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand);
		local off = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);
		return main != null && off == null && main.isDoubleGrippable();
	}
	
	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInSwords ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			local items = this.m.Container.getActor().getItems();
			local mhand = items.getItemAtSlot(this.Const.ItemSlot.Mainhand);

			if (mhand != null)
			{
				_properties.DamageRegularMin -= mhand.m.RegularDamage;
				_properties.DamageRegularMax -= mhand.m.RegularDamageMax;
				_properties.DamageArmorMult /= mhand.m.ArmorDamageMult;
				_properties.DamageDirectAdd -= mhand.m.DirectDamageAdd;
			}

			_properties.DamageRegularMin += 20;
			_properties.DamageRegularMax += 35;
			_properties.DamageArmorMult *= 0.4;
			
			if (_properties.IsSpecializedInSwords && !this.m.IsRestrained)
			{
				_properties.DamageRegularMin += 10;
				_properties.DamageRegularMax += 10;
				_properties.DamageArmorMult *= 1.1;
			}
			
			if (this.canDoubleGrip())
			{
				_properties.DamageTotalMult /= 1.25;
			}
		}
	}

});

