this.orc_young_medium_base_armor <- this.inherit("scripts/items/legend_armor/legend_armor", {
	m = {},
	function create()
	{
		this.legend_armor.create();
		this.m.Variants = [
			3
		];
		this.m.Variant = 3;
		this.updateVariant();
		this.m.ID = "armor.body.orc_young_medium_armor";
		this.m.Name = "Tough Hide Armor";
		this.m.Description = "A makeshift hide armor. But with hide at better quality.";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ArmorLeatherImpact;
		this.m.Condition = 80;
		this.m.ConditionMax = 80;
		this.m.StaminaModifier = -14;
		this.blockUpgrades();
		this.m.Blocked[this.Const.Items.ArmorUpgrades.Attachment] = false;
		this.m.Blocked[this.Const.Items.ArmorUpgrades.Rune] = false;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_orc_01_armor_03";
		this.m.SpriteDamaged = "bust_orc_01_armor_03_damaged";
		this.m.SpriteCorpse = "bust_orc_01_armor_03_dead";
		this.m.Icon = "armor/icon_orc_01_armor_03.png";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
	}

	function onEquip()
	{
		this.legend_armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}
	
});

