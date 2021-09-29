this.getroottable().HexenHooks.hookItem <- function ()
{
	//Change this goblin balls sprite so it doesn't look too weird when your goblin is on a mount
	::mods_hookExactClass("items/weapons/greenskins/goblin_spiked_balls", function(obj) 
	{
		local oldFunction = obj.create;
		obj.create = function()
		{
			oldFunction();
			this.m.ArmamentIcon = "icon_goblin_balls";
		}
	});

	::mods_hookExactClass("items/item_container", function ( o )
	{
		o.drop <- function ( item )
		{
			if (!this.m.Actor.isPlacedOnMap())
			{
				return;
			}

			local _tile = this.m.Actor.getTile();
			item.m.IsDroppedAsLoot = true;
			item.drop(_tile);
			_tile.IsContainingItemsFlipped = true;
		};
		o.equip = function ( _item )
		{
			if (_item == null)
			{
				return false;
			}

			if (_item.getSlotType() == this.Const.ItemSlot.None)
			{
				return false;
			}

			if (_item.getCurrentSlotType() != this.Const.ItemSlot.None)
			{
				this.logWarning("Attempted to equip item " + _item.getName() + ", but it is already placed somewhere else");
				return false;
			}

			if (this.isThisSlotBlocked(_item.getSlotType()))
			{
				return false;
			}

			if (this.getActor().getFlags().has("human"))
			{
				local invalid_armor = [
					"armor.body.legend_orc_behemoth_armor",
					"armor.body.orc_berserker_light_armor",
					"armor.body.orc_berserker_medium_armor",
					"armor.body.orc_elite_heavy_armor",
					"armor.body.orc_warlord_armor",
					"armor.body.orc_warrior_heavy_armor",
					"armor.body.orc_warrior_light_armor",
					"armor.body.orc_warrior_medium_armor",
					"armor.body.orc_young_heavy_armor",
					"armor.body.orc_young_light_armor",
					"armor.body.orc_young_medium_armor",
					"armor.body.orc_young_very_light_armor",
					"armor.body.goblin_heavy_armor",
					"armor.body.goblin_leader_armor",
					"armor.body.goblin_light_armor",
					"armor.body.goblin_medium_armor",
					"armor.body.goblin_shaman_armor",
					"armor.body.goblin_skirmisher_armor",
					"armor.body.unhold_armor_heavy",
					"armor.body.unhold_armor_light",
				];

				if (_item.isItemType(this.Const.Items.ItemType.Armor) && invalid_armor.find(_item.getID()) != null)
				{
					return false;	
				}

				local invalid_helmet = [
					"armor.head.orc_berserker_helmet",
					"armor.head.orc_warrior_heavy_helmet",
					"armor.head.orc_warrior_light_helmet",
					"armor.head.orc_warrior_medium_helmet",
					"armor.head.orc_young_heavy_helmet",
					"armor.head.orc_young_light_helmet",
					"armor.head.orc_young_medium_helmet",
					"armor.head.orc_elite_heavy_helmet",
					"armor.head.legend_orc_behemoth_helmet",
					"armor.head.orc_warlord_helmet",
					"armor.head.goblin_heavy_helmet",
					"armor.head.goblin_leader_helmet",
					"armor.head.goblin_light_helmet",
					"armor.head.goblin_shaman_helmet",
					"armor.head.goblin_skirmisher_helmet",
					"armor.head.unhold_helmet_heavy",
					"armor.head.unhold_helmet_light",
				];

				if (_item.isItemType(this.Const.Items.ItemType.Helmet) && invalid_helmet.find(_item.getID()) != null)
				{
					return false;
				}
			}

			if (!this.getActor().getFlags().has("IsHorseRider"))
			{
				if (_item.getItemType() == this.Const.Items.ItemType.HorseArmor && !this.getActor().getFlags().has("IsHorse") || _item.getItemType() != this.Const.Items.ItemType.HorseArmor && this.getActor().getFlags().has("IsHorse"))
				{
					return false;
				}

				if (_item.getItemType() == this.Const.Items.ItemType.HorseHelmet && !this.getActor().getFlags().has("IsHorse") || _item.getItemType() != this.Const.Items.ItemType.HorseHelmet && this.getActor().getFlags().has("IsHorse"))
				{
					return false;
				}
			}

			local vacancy = -1;

			for( local i = 0; i < this.m.Items[_item.getSlotType()].len(); i = i )
			{
				if (this.m.Items[_item.getSlotType()][i] == null)
				{
					vacancy = i;
					break;
				}

				i = ++i;
			}

			local blocked = -1;

			if (_item.getBlockedSlotType() != null)
			{
				for( local i = 0; i < this.m.Items[_item.getBlockedSlotType()].len(); i = i )
				{
					if (this.m.Items[_item.getBlockedSlotType()][i] == null)
					{
						blocked = i;
						break;
					}

					i = ++i;
				}
			}

			if (vacancy != -1 && (_item.getBlockedSlotType() == null || blocked != -1))
			{
				if (_item.getContainer() != null)
				{
					_item.getContainer().unequip(_item);
				}

				this.m.Items[_item.getSlotType()][vacancy] = _item;

				if (_item.getBlockedSlotType() != null)
				{
					this.m.Items[_item.getBlockedSlotType()][blocked] = -1;
				}

				_item.setContainer(this);
				_item.setCurrentSlotType(_item.getSlotType());

				if (_item.getSlotType() == this.Const.ItemSlot.Bag)
				{
					_item.onPutIntoBag();
				}
				else
				{
					if ("onActorEquip" in this.m.Actor.get())
					{
						this.m.Actor.onActorEquip(_item);
					}

					_item.onEquip();

					if ("onActorAfterEquip" in this.m.Actor.get())
					{
						this.m.Actor.onActorAfterEquip(_item);
					}
				}

				this.m.Actor.getSkills().update();
				return true;
			}
			else
			{
				return false;
			}
		};
		o.unequip = function( _item )
		{
			if (_item == null || _item == -1)
			{
				return;
			}

			if (_item.getCurrentSlotType() == this.Const.ItemSlot.None || _item.getCurrentSlotType() == this.Const.ItemSlot.Bag)
			{
				this.logWarning("Attempted to unequip item " + _item.getName() + ", but is not equipped");
				return false;
			}

			for( local i = 0; i < this.m.Items[_item.getSlotType()].len(); i = i )
			{
				if (this.m.Items[_item.getSlotType()][i] == _item)
				{
					if ("onActorUnequip" in this.m.Actor.get())
					{
						this.m.Actor.onActorUnequip(_item);
					}

					_item.onUnequip();
					_item.setContainer(null);
					_item.setCurrentSlotType(this.Const.ItemSlot.None);
					this.m.Items[_item.getSlotType()][i] = null;
					
					if ("onActorAfterUnequip" in this.m.Actor.get())
					{
						this.m.Actor.onActorAfterUnequip(_item);
					}

					if (_item.getBlockedSlotType() != null)
					{
						for( local i = 0; i < this.m.Items[_item.getBlockedSlotType()].len(); i = i )
						{
							if (this.m.Items[_item.getBlockedSlotType()][i] == -1)
							{
								this.m.Items[_item.getBlockedSlotType()][i] = null;
								break;
							}

							i = ++i;
						}
					}

					if (this.m.Actor != null && !this.m.Actor.isNull() && this.m.Actor.isAlive())
					{
						this.m.Actor.getSkills().update();
					}

					return true;
				}

				i = ++i;
			}

			return false;
		}
		o.onActorDied = function( _onTile )
		{
			this.m.IsUpdating = true;

			for( local i = 0; i < this.Const.ItemSlot.COUNT; i = i )
			{
				for( local j = 0; j < this.m.Items[i].len(); j = j )
				{
					if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
					{
					}
					else
					{
						this.m.Items[i][j].onActorDied(_onTile);

						if ("isMounted" in this.m.Actor.get())
						{
							this.m.Actor.m.Mount.onActorDied(_onTile);
						}
					}

					j = ++j;
				}

				i = ++i;
			}

			this.m.IsUpdating = false;
		};
		o.unequipNoUpdate <- function ( _item )
		{
			if (_item == null || _item == -1)
			{
				return;
			}

			if (_item.getCurrentSlotType() == this.Const.ItemSlot.None || _item.getCurrentSlotType() == this.Const.ItemSlot.Bag)
			{
				this.logWarning("Attempted to unequip item " + _item.getName() + ", but is not equipped");
				return false;
			}

			for( local i = 0; i < this.m.Items[_item.getSlotType()].len(); i = i )
			{
				if (this.m.Items[_item.getSlotType()][i] == _item)
				{
					this.m.Items[_item.getSlotType()][i] = null;

					if (_item.getBlockedSlotType() != null)
					{
						for( local i = 0; i < this.m.Items[_item.getBlockedSlotType()].len(); i = i )
						{
							if (this.m.Items[_item.getBlockedSlotType()][i] == -1)
							{
								this.m.Items[_item.getBlockedSlotType()][i] = null;
								break;
							}

							i = ++i;
						}
					}

					return true;
				}

				i = ++i;
			}

			return false;
		};
		o.transferToList <- function ( _stash )
		{
			for( local i = 0; i < this.Const.ItemSlot.COUNT; i = i )
			{
				for( local j = 0; j < this.m.Items[i].len(); j = j )
				{
					if (this.m.Items[i][j] == null || this.m.Items[i][j] == -1)
					{
					}
					else
					{
						local item = this.m.Items[i][j];

						if (item.isEquipped())
						{
							this.unequip(item);
						}
						else
						{
							this.removeFromBag(item);
						}

						_stash.push(item);
					}

					j = ++j;
				}

				i = ++i;
			}
		};
	});

	//show blocked equipment slot
	::mods_hookNewObject("ui/global/data_helper", function ( obj )
	{
		local oldFunction = obj.addCharacterToUIData;
		obj.addCharacterToUIData = function( _entity, _target )
		{
			if (_entity.isSummoned())
			{
				_target.name <- _entity.getNameOnly();
				_target.title <- _entity.getTitle();
				_target.imagePath <- _entity.getImagePath();
				_target.imageOffsetX <- _entity.getImageOffsetX();
				_target.imageOffsetY <- _entity.getImageOffsetY();
				_target.perkPoints <- 0;
				_target.perkPointsSpent <- 0;
				_target.level <- 1;
				_target.levelUp <- null;
				_target.daysWithCompany <- 1;
				_target.xpValue <- 0;
				_target.xpValueMax <- 999999;
				_target.dailyMoneyCost <- 0;
				_target.daysWounded <- 0;
				_target.leveledUp <- false;
				_target.moodIcon <- "ui/icons/mood_04.png";
				_target.isPlayerCharacter <- false;
				_target.background <- "";
				_target.inReserves <- false;
				_target.stabled <- false;
				_target.riderID <- "";
				return;
			}

			oldFunction(_entity, _target);
		}
		
		obj.convertBlockedSlotsToUIData <- function( _items, _target )
		{
			if (_items == null)
			{
				return;
			}

			_target.body <- _items.isThisSlotBlocked(this.Const.ItemSlot.Body);
			_target.head <- _items.isThisSlotBlocked(this.Const.ItemSlot.Head)
			_target.mainhand <- _items.isThisSlotBlocked(this.Const.ItemSlot.Mainhand);
			_target.offhand <- _items.isThisSlotBlocked(this.Const.ItemSlot.Offhand);
			_target.accessory <- _items.isThisSlotBlocked(this.Const.ItemSlot.Accessory);
			_target.ammo <- _items.isThisSlotBlocked(this.Const.ItemSlot.Ammo);
		}

		local oldFunction = obj.convertEntityToUIData;
		obj.convertEntityToUIData = function( _entity, _activeEntity )
		{
			local result = oldFunction(_entity, _activeEntity);
			local items = _entity.getItems();

			if (items != null && this.isKindOf(items, "nggh707_item_container"))
			{
				result.restriction <- {};
				this.convertBlockedSlotsToUIData(items, result.restriction);
			}

			return result;
		}
	});

	delete this.HexenHooks.hookItem;
}
