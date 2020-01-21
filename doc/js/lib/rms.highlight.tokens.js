export const macro = [
  "#define",
  "#undefine",
  "#const",
  "if",
  "elseif",
  "else",
  "endif",
  "start_random",
  "percent_chance",
  "end_random",
  "#include",
  "#include_drs",
  "rnd(",
  ")",
  ","
];

export const label = [
  "<PLAYER_SETUP>",
  "<LAND_GENERATION>",
  "<CLIFF_GENERATION>",
  "<TERRAIN_GENERATION>",
  "<OBJECTS_GENERATION>",
  "<CONNECTION_GENERATION>",
  "<ELEVATION_GENERATION>",
];

export const begin_comment = [
  "/*"
];

export const end_comment = [
  "*/"
]

export const comment = begin_comment.concat(end_comment);

export const braces = [
  "{",
  "}",
];

export const structure = comment.concat(braces);

export const command = [
  "random_placement",
  "grouped_by_team",
  "nomad_resources",
  "ai_info_map_type",

  "create_player_lands",
  "create_land",
  "enable_waves",
  "color_correction",

  "create_terrain",

  "create_elevation",

  "min_number_of_cliffs",
  "max_number_of_cliffs",
  "min_length_of_cliff",
  "max_length_of_cliff",
  "cliff_curliness",
  "min_distance_cliffs",
  "min_terrain_distance",

  "create_object",

  "create_connect_all_players_land",
  "create_connect_teams_lands",
  "create_connect_same_land_zones",
  "create_connect_all_lands",
  "create_connect_to_nonplayer_land",
];

export const attribute = [
  "base_terrain",

  "min_distance",
  "max_distance",
  "set_position",
  "land_percent",
  "terrain_type",
  "base_size",
  "left_border",
  "right_border",
  "top_border",
  "bottom_border",
  "border_fuzziness",
  "zone",
  "set_zone_by_team",
  "set_zone_randomly",
  "other_zone_avoidance_distance",
  "assign_to_player",
  "percent_of_land",
  "number_of_clumps",
  "spacing_to_other_terrain_types",
  "set_scaling_to_map_size",
  "number_of_groups",
  "number_of_objects",
  "group_variance",
  "group_placement_radius",
  "set_loose_grouping",
  "set_tight_grouping",
  "terrain_to_place_on",
  "set_gaia_object_only",
  "set_place_for_every_player",
  "place_on_specific_land_id",
  "min_distance_to_players",
  "max_distance_to_players",
  "land_position",
  "land_id",
  "clumping_factor",
  "number_of_tiles",
  "set_scale_by_groups",
  "set_scale_by_size",
  "set_avoid_player_start_areas",
  "min_distance_group_placement",
  "spacing",
  "default_terrain_replacement",
  "replace_terrain",
  "terrain_cost",
  "terrain_size",
  "min_placement_distance",
  "set_scaling_to_player_number",
  "height_limits",
  "set_flat_terrain_only",
  "max_distance_to_other_zones",
  "temp_min_distance_group_placement",
  "base_elevation",
  "direct_placement",
  "resource_delta",
  "guard_state",
  "assign_to",
  "terrain_mask",
  "circle_radius",
  "base_layer",
  "place_on_forest_zone",
  "avoid_forest_zone",
  "find_closest",
  "actor_area",
  "actor_area_radius",
  "actor_area_to_place_in",
  "avoid_actor_area",
  "avoid_all_actor_areas",
  "layer_to_place_on",
  "force_placement",
  "second_object"
];

export const setting = [
	"TINY_MAP",
	"SMALL_MAP",
	"MEDIUM_MAP",
	"LARGE_MAP",
	"HUGE_MAP",
	"GIGANTIC_MAP",
	"LUDIKRIS_MAP",
	"FIXED_POSITIONS",
	"DEATH_MATCH",
	"HIGH_RESOURCES",
	"MEDIUM_RESOURCES",
	"LOW_RESOURCES",
	"DEFAULT_RESOURCES",
	"REGICIDE",
	"CAPTURE_THE_RELIC",
	"BATTLE_ROYALE",
	"EMPIRE_WARS",
	"KING_OT_HILL",
	"WONDER_RACE",
	"DEFEND_WONDER",
	"TURBO_RANDOM_MAP",
	"TURBO_MODE",
	"TEAM_POSITIONS",
	"INFINITE_RESOURCES",
	"RANDOM_RESOURCES",
	"FULL_TECH_TREE",
	"AI_PLAYERS",
	"DE_AVAILABLE",
	"%d_PLAYER_GAME",
];

export const syntax = command.concat(attribute);
export const keyword = syntax.concat(label).concat(macro);
export const constant = setting;

export const virtual_classes = [
  "integer", "name", "whitespace"
];

export const classes = [
  "setting", "command", "attribute", "label", "macro",
  "begin_comment",
  "end_comment",
  "comment",
  "structure",
  "syntax",
  "keyword", "constant"
];
