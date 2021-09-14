local gt = this.getroottable();

gt.Const.MC_Combat <- {
	NoStaffDamageMult = 0.5,
	NoStaffWithMasteryDamageMult = 0.85,
};

gt.Const.MC_Backgrounds <- [
	"battlemage_background",
	"diabolist_background",
	"elementalist_background",
	"geomancer_background"
];

gt.Const.MC_Job <- {
	None = 0,
	BattleMage = 1,
	Elementalist = 2,
	Geomancer = 3,
	Diabolist = 4,
	Necromancer = 5,
	Spellknight = 6,
	Hexen = 7,
	COUNT = 8,

	function pickSkillRandomly( _job , _tier ) 
	{
		local lib = this.Const.MC_Magic;
		if (_job < 0 || _job > lib.len() - 1) _job = this.None;
		if (_tier < 0 || _tier >= this.Const.MC_MagicTier.COUNT) _tier = this.Const.MC_MagicTier.Basic;
		local available_skills = lib[_job][_tier];
		if (available_skills.len() == 0) return null;
		return ::mc_randArray(available_skills);
	}
};

gt.Const.MC_MagicTier <- {
	Basic = 0,
	Intermediate = 1,
	Adept = 2,
	Master = 3,
	COUNT = 4,
};

gt.Const.MC_Magic <- [
	//None = 0
	[
		["actives/mage_legend_magic_missile"],
		["actives/mage_legend_magic_chain_lightning"],
		["actives/mage_legend_magic_burning_hands"],
		["actives/mage_legend_magic_teleport"]
	],

	//BattleMage = 1
	[
		["mc_actives/mc_BAT_energy_drain"],
		["mc_actives/mc_BAT_silver_lance"],
		["mc_actives/mc_BAT_teleportation"],
		[]
	],

	//Elementalist = 2
	[
		["mc_actives/mc_ELE_lightning"],
		["mc_actives/mc_ELE_root_or_uproot"],
		["mc_actives/mc_ELE_elemental_storm"],
		[]
	],

	//Geomancer = 3
	[
		["mc_actives/mc_GEO_earthquake"],
		["mc_actives/mc_GEO_earthen_puppet"],
		["mc_actives/mc_GEO_lower_tile", "mc_actives/mc_GEO_raise_tile"],
		[]
	],

	//Diabolist = 4
	[
		["mc_actives/mc_DIA_shadow_demon"],
		["mc_actives/mc_DIA_siphon_strength"],
		["mc_actives/mc_DIA_curse"],
		[]
	],

	//Necromancer = 5
	[
		[],
		[],
		[],
		[]
	],

	//Spellknight = 6
	[
		[],
		[],
		[],
		[]
	],

	//Hexen = 7
	[
		[],
		[],
		[],
		[]
	],
];

gt.Const.SmokeParticles <- [
	{
		Delay = 0,
		Quantity = 50,
		LifeTimeQuantity = 0,
		SpawnRate = 9,
		Brushes = [
			"ash_light_01",
			"ash_light_02"
		],
		Stages = [
			{
				LifeTimeMin = 0.75,
				LifeTimeMax = 1.25,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.5,
				ScaleMax = 0.75,
				RotationMin = 0,
				RotationMax = 359,
				TorqueMin = -10,
				TorqueMax = 10,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.5, 0.5),
				DirectionMax = this.createVec(0.5, 0.5),
				SpawnOffsetMin = this.createVec(-50, -40),
				SpawnOffsetMax = this.createVec(50, 20),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = this.createColor("ffffffed"),
				ColorMax = this.createColor("ffffffed"),
				ScaleMin = 0.75,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 1.0,
				ScaleMax = 1.5,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			}
		]
	},
	{
		Delay = 0,
		Quantity = 10,
		LifeTimeQuantity = 0,
		SpawnRate = 2,
		Brushes = [
			"dust_light_01",
			"dust_light_02"
		],
		Stages = [
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 0.75,
				ScaleMax = 1.0,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.5, 0.5),
				DirectionMax = this.createVec(0.5, 0.5),
				SpawnOffsetMin = this.createVec(-50, -40),
				SpawnOffsetMax = this.createVec(50, 10),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 4.0,
				LifeTimeMax = 6.0,
				ColorMin = this.createColor("ffffffef"),
				ColorMax = this.createColor("ffffffef"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				DirectionMin = this.createVec(-0.4, 0.6),
				DirectionMax = this.createVec(0.4, 0.6),
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			},
			{
				LifeTimeMin = 0.5,
				LifeTimeMax = 1.0,
				ColorMin = this.createColor("ffffff00"),
				ColorMax = this.createColor("ffffff00"),
				ScaleMin = 1.0,
				ScaleMax = 1.25,
				VelocityMin = 10,
				VelocityMax = 30,
				ForceMin = this.createVec(0, 0),
				ForceMax = this.createVec(0, 10),
				FlickerEffect = false
			}
		]
	}
];

gt.Const.Strings.PerkName.MC_MagicTraining1 <- "Magical Study - 1";
gt.Const.Strings.PerkName.MC_MagicTraining2 <- "Magical Study - 2";
gt.Const.Strings.PerkName.MC_MagicTraining3 <- "Magical Study - 3";
gt.Const.Strings.PerkName.MC_MagicTraining4 <- "Magical Study - 4";
gt.Const.Strings.PerkName.MC_MagicTraining5 <- "Magical Study - 5";

gt.Const.Strings.PerkDescription.MC_MagicTraining1 <- "Improve the efficiency of your magic skills by [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color]. Also every turn, you has [color=" + this.Const.UI.Color.PositiveValue + "]10%[/color] to gain [color=" + this.Const.UI.Color.PositiveValue + "]+25%[/color] Resolve for a turn. \n\n[color=#0b0084]From the Magic perk group[/color]";
gt.Const.Strings.PerkDescription.MC_MagicTraining2 <- "Learn a random active skill corresponding to your magic art style. \n\n[color=#0b0084]From the Magic perk group[/color]";
gt.Const.Strings.PerkDescription.MC_MagicTraining3 <- "You have trained your mind to the best of it, this helps a lot in combat. Gain a third of your base Resolve as Melee and Ranged skill, with a minimum bonus of 5. [color=" + this.Const.UI.Color.NegativeValue + "]Requiring to equip a magic wand[/color]. \n\n[color=#0b0084]From the Magic perk group[/color]";
gt.Const.Strings.PerkDescription.MC_MagicTraining4 <- "Learn another random active skill corresponding to your magic art style. \n\n[color=#0b0084]From the Magic perk group[/color]";
gt.Const.Strings.PerkDescription.MC_MagicTraining5 <- "Mastered your magically skill. Gain [color=" + this.Const.UI.Color.NegativeValue + "]+5%[/color] resolve. Your magic skills build up [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color] less Fatigue and reduce the penalty for not using magic staff from [color=" + this.Const.UI.Color.NegativeValue + "]-50%[/color] down to [color=" + this.Const.UI.Color.NegativeValue + "]-15%[/color], also let you gain full effect of 'Magical Study - 3' even when not using a magic staff. \n\n[color=#0b0084]From the Magic perk group[/color]";

gt.Const.Perks.PerkDefObjects.extend([
	{
		ID = "perk.magic_training_1",
		Script = "scripts/skills/perks/perk_magic_training_1",
		Name = this.Const.Strings.PerkName.MC_MagicTraining1,
		Tooltip = this.Const.Strings.PerkDescription.MC_MagicTraining1,
		Icon = "ui/perks/perk_magic_training_1.png",
		IconDisabled = "ui/perks/perk_magic_training_1_sw.png",
		Const = "MC_MagicTraining1"
	},
	{
		ID = "perk.magic_training_2",
		Script = "scripts/skills/perks/perk_magic_training_2",
		Name = this.Const.Strings.PerkName.MC_MagicTraining2,
		Tooltip = this.Const.Strings.PerkDescription.MC_MagicTraining2,
		Icon = "ui/perks/perk_magic_training_2.png",
		IconDisabled = "ui/perks/perk_magic_training_2_sw.png",
		Const = "MC_MagicTraining2"
	},
	{
		ID = "perk.magic_training_3",
		Script = "scripts/skills/perks/perk_magic_training_3",
		Name = this.Const.Strings.PerkName.MC_MagicTraining3,
		Tooltip = this.Const.Strings.PerkDescription.MC_MagicTraining3,
		Icon = "ui/perks/perk_magic_training_3.png",
		IconDisabled = "ui/perks/perk_magic_training_3_sw.png",
		Const = "MC_MagicTraining3"
	},
	{
		ID = "perk.magic_training_4",
		Script = "scripts/skills/perks/perk_magic_training_4",
		Name = this.Const.Strings.PerkName.MC_MagicTraining4,
		Tooltip = this.Const.Strings.PerkDescription.MC_MagicTraining4,
		Icon = "ui/perks/perk_magic_training_4.png",
		IconDisabled = "ui/perks/perk_magic_training_4_sw.png",
		Const = "MC_MagicTraining4"
	},
	{
		ID = "perk.magic_training_5",
		Script = "scripts/skills/perks/perk_magic_training_5",
		Name = this.Const.Strings.PerkName.MC_MagicTraining5,
		Tooltip = this.Const.Strings.PerkDescription.MC_MagicTraining5,
		Icon = "ui/perks/perk_magic_training_5.png",
		IconDisabled = "ui/perks/perk_magic_training_5_sw.png",
		Const = "MC_MagicTraining5"
	},
]);

gt.Const.Perks.PerkDefs.clear();

foreach( i, v in gt.Const.Perks.PerkDefObjects )
{
	gt.Const.Perks.PerkDefs[v.Const] <- i;
}

gt.Const.Perks.MC_MagicTree <- {
	ID = "MC_MagicTree",
	Name = "MC Magic",
	Descriptions = [
		"MC"
	],
	Tree = [
		[
			gt.Const.Perks.PerkDefs.MC_MagicTraining1
		],
		[],
		[
			gt.Const.Perks.PerkDefs.MC_MagicTraining2
		],
		[
			gt.Const.Perks.PerkDefs.MC_MagicTraining3
		],
		[
			gt.Const.Perks.PerkDefs.MC_MagicTraining4
		],
		[
			gt.Const.Perks.PerkDefs.MC_MagicTraining5
		],
		[]
	]
};


