enum Skills {
  Attack,
  Defence,
  Strength,
  Hitpoints,
  Ranged,
  Prayer,
  Magic,
  Cooking,
  Woodcutting,
  Fletching,
  Fishing,
  Firemaking,
  Crafting,
  Smithing,
  Mining,
  Herblore,
  Agility,
  Thieving,
  Slayer,
  Farming,
  Runecraft,
  Hunter,
  Construction,
}

extension SkillsExtension on Skills {
  static const skillIds = {
    Skills.Attack: 0,
    Skills.Defence: 1,
    Skills.Strength: 2,
    Skills.Hitpoints: 3,
    Skills.Ranged: 4,
    Skills.Prayer: 5,
    Skills.Magic: 6,
    Skills.Cooking: 7,
    Skills.Woodcutting: 8,
    Skills.Fletching: 9,
    Skills.Fishing: 10,
    Skills.Firemaking: 11,
    Skills.Crafting: 12,
    Skills.Smithing: 13,
    Skills.Mining: 14,
    Skills.Herblore: 15,
    Skills.Agility: 16,
    Skills.Thieving: 17,
    Skills.Slayer: 18,
    Skills.Farming: 19,
    Skills.Runecraft: 20,
    Skills.Hunter: 21,
    Skills.Construction: 22,
  };

  static const skillNames = {
    Skills.Attack: 'Attack',
    Skills.Defence: 'Defence',
    Skills.Strength: 'Strength',
    Skills.Hitpoints: 'Hitpoints',
    Skills.Ranged: 'Ranged',
    Skills.Prayer: 'Prayer',
    Skills.Magic: 'Magic',
    Skills.Cooking: 'Cooking',
    Skills.Woodcutting: 'Woodcutting',
    Skills.Fletching: 'Fletching',
    Skills.Fishing: 'Fishing',
    Skills.Firemaking: 'Firemaking',
    Skills.Crafting: 'Crafting',
    Skills.Smithing: 'Smithing',
    Skills.Mining: 'Mining',
    Skills.Herblore: 'Herblore',
    Skills.Agility: 'Agility',
    Skills.Thieving: 'Thieving',
    Skills.Slayer: 'Slayer',
    Skills.Farming: 'Farming',
    Skills.Runecraft: 'Runecraft',
    Skills.Hunter: 'Hunter',
    Skills.Construction: 'Construction',
  };

  static const skillImages = {
    Skills.Attack: 'Attack_icon',
    Skills.Defence: 'Defence_icon',
    Skills.Strength: 'Strength_icon',
    Skills.Hitpoints: 'Hitpoints_icon',
    Skills.Ranged: 'Ranged_icon',
    Skills.Prayer: 'Prayer_icon',
    Skills.Magic: 'Magic_icon',
    Skills.Cooking: 'Cooking_icon',
    Skills.Woodcutting: 'Woodcutting_icon',
    Skills.Fletching: 'Fletching_icon',
    Skills.Fishing: 'Fishing_icon',
    Skills.Firemaking: 'Firemaking_icon',
    Skills.Crafting: 'Crafting_icon',
    Skills.Smithing: 'Smithing_icon',
    Skills.Mining: 'Mining_icon',
    Skills.Herblore: 'Herblore_icon',
    Skills.Agility: 'Agility_icon',
    Skills.Thieving: 'Thieving_icon',
    Skills.Slayer: 'Slayer_icon',
    Skills.Farming: 'Farming_icon',
    Skills.Runecraft: 'Runecraft_icon',
    Skills.Hunter: 'Hunter_icon',
    Skills.Construction: 'Construction_icon',
  };

  int get skillId => skillIds[this];
  String get skillName => skillNames[this];
  String get skillImage => skillImages[this];
}
