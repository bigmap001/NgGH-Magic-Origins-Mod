this.goblin_skirmisher_armor <- this.inherit("scripts/items/armor/armor", {
	m = {},
	function create()
	{
		this.armor.create();
		this.m.Variant = this.Math.rand(1, 3);
		this.updateVariant();
		this.m.ID = "armor.body.goblin_skirmisher_armor";
		this.m.Name = "Goblin Camouflage Outfit";
		this.m.Description = "A simple leather cloth that has been fashioned to look like bushes.";
		this.m.IconLarge = "armor/inventory_goblin_body_armor.png";
		this.m.SlotType = this.Const.ItemSlot.Body;
		this.m.ShowOnCharacter = true;
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Condition = 40;
		this.m.ConditionMax = 40;
		this.m.StaminaModifier = 0;
		this.m.Value = 40;
	}

	function updateVariant()
	{
		this.m.Sprite = "bust_goblin_04_armor_0" + this.m.Variant;
		this.m.SpriteDamaged = "bust_goblin_04_armor_0" + this.m.Variant + "_damaged";
		this.m.SpriteCorpse = "bust_goblin_04_armor_0" + this.m.Variant + "_dead";
		this.m.Icon = "armor/icon_goblin_04_armor_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.armor.onEquip();
		this.m.IsDroppedAsLoot = ("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.hexen";
	}

});

