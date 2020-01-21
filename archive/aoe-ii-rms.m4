m4_define([doc_chapter], [[#]chapter $@])
m4_define([doc_category], [[#]category $@])

m4_define([doc_syntax], [[#]syntax $1 $2][[]][m4_ifnblank([$3], [
  #syntax_params $3
])])

m4_define([doc_command], [doc_syntax(command, $@)])
m4_define([doc_attribute], [doc_syntax(attribute, $@)])


m4_define([doc_argument], [#argument $1
    #argument_type $2
    #argument_default $3
    #details
      $4
    #end_details
  #end_argument])

m4_define([doc_text], [#details
      $1
    #end_details])

m4_divert()
doc_chapter(Commands by Category)

doc_category(PLAYER_SETUP)
    doc_command([random_placement])
    doc_command([grouped_by_team])
    doc_command([direct_placement])
    doc_command([ai_info_map_type], [TYPE NOMAD MICHI SHOW_TYPE])
        doc_argument(TYPE, Map Type Constant, [],
          [One of the predefined map type constants.])
        doc_argument(NOMAD, doc_pre([0]) or doc_pre([1]), [],
          [Indicates to the Ai whether the map has nomad starts or not.])
        doc_argument(MICHI, doc_pre([0]) or doc_pre([1]), [],
          [Indicates to the Ai whether the map has michi starts or not. ])
        doc_argument(SHOW_TYPE, doc_pre([0]) or doc_pre([1]), [],
          [When set, the map type will be shown in objectives.])

doc_category(LAND_GENERATION)
  doc_command([base_terrain], [TYPE])
    doc_argument([TYPE], [Terrain Constant], [GRASS],
      [Specifies which terrain to use to initially fill the map.])


  doc_command([enable_waves], [ENABLE])
    doc_argument([ENABLE], [doc_pre([1]) or doc_pre([0])], [1], [
      When set to doc_pre([1]), the new wave effects will be used.

      This attribute allows map designers to disable waves on maps where
      they do not match the aesthetic.
    ])

  doc_command([create_player_lands], [{...}])
    doc_text([
      Creates a land for every player.

      If you do not place player lands, the game will spawn a town
      center and villagers for them randomly. You will be unable to spawn
      resources for these randomly placed town centers.

      You may alternatively use the doc_ref(assign_to_player) attribute inside of a
      doc_ref(create_land) command to create lands for players individually.
    ])

  doc_command([create_land], [{...}])
    doc_text([
      Creates a single land.

      The land will be neutral by default, but that
      can be changed via attributes.
    ])

  doc_hr()

  doc_attribute([terrain_type], [TYPE])
    doc_argument(TYPE, Terrain Constant, [GRASS], [
      Defines the base terrain type to use for this land.
    ])

  doc_attribute([land_percent], [%])
    doc_argument(%, Integer Percentage (0..100), [100], [
      Defines what percentage of the total map area should be used for this
      land.

      If used inside of doc_ref(create_player_lands), this percentage is
      shared among doc_strong([all]) player lands.
    ])
    doc_text([
      doc_ref(land_percent) and doc_ref(number_of_tiles) are mutually
      exclusive.
    ])

  doc_attribute([number_of_tiles], [N])
    doc_argument(N, Integer Tile Count, [], [
      Defines a fixed size for the land in tiles.

      If used inside of doc_ref(create_player_lands), each player land will
      be sized to doc_pre([N]) tiles. This is in contrast to doc_pre([land_percent]) where
      player lands *share* the defined area.
    ])
    doc_text([
      doc_ref(land_percent) and doc_ref(number_of_tiles) are mutually
      exclusive.
    ])

  doc_attribute([base_size], [RADIUS])
    doc_argument([RADIUS], [Integer Radius], [0], [
      Defines a minimum radius for the land, counting out from the center
      tile.

      For example, doc_pre([base_size 3]) would define a land that is minimally
      7x7.
    ])

  doc_attribute([base_elevation])
    doc_argument([HEIGHT], [Integer Elevation (1..7)], [0], [
      Defines the base elevation for the land.

      If used, an doc_ref(doc_pre([<ELEVATION_GENERATION>]), ELEVATION_GENERATION)
      section must be present.
    ])

  doc_attribute([left_border], [%])
    doc_argument(%, Integer Percentage, [100], [
      Defines how close to the edge of the map a land can spread.

      Negative values may be useful in conjunction with doc_ref(land_position)
      to encourage lands to spread closer to the edge of the map. If
      a negative border is specified and doc_pre([land_position]) is not used, the
      game may crash if the land origin is placed outside of the map.

      doc_strong([Note:]) Using this attribute with player lands is buggy in some
      versions of the game.
    ])

  doc_attribute([right_border], [%])
    doc_quote([see doc_ref(left_border)])
  doc_attribute([top_border], [%])
    doc_quote([see doc_ref(left_border)])
  doc_attribute([bottom_border], [%])
    doc_quote([see doc_ref(left_border)])

  doc_attribute([land_position], [X% Y%])
    doc_argument([[X%, Y%]], Integer Percentage, [], [
      Defines a fixed origin for the land in terms of a percent of the total
      width and height of the map.

      As of DE, this attribute may be used in conjunction with
      doc_ref(assign_to_player) so long as doc_ref(direct_placement) is
      specified in the doc_pre([<PLAYER_SETUP>]) section. This was not possible in
      previous versions.
    ])

  doc_attribute([border_fuzziness], [VALUE])
    doc_argument(VALUE, Integer (0..100), [20], [
      Defines how relaxed/strict the borders are for this land. At 0, the
      borders are ignored. At 100, the land can not exceed its borders at all.
    ])

  doc_attribute([clumping_factor], [VALUE])
    doc_argument(VALUE, Integer (-100..99), [8], [
      Higher values here will cause lands to prefer to spread to tiles
      closer to their origin, creating rounder lands.
    ])

  doc_attribute([zone], [ID])
    doc_argument(ID, Integer (Any Positive), [8], [
      Define an explicit zone for this terrain.

      doc_strong([Note:]) Using zone 99 may crash the game.
    ])
    doc_text([
      doc_ref(zone), doc_ref(set_zone_randomly), and doc_ref(set_zone_by_team)
      are mutually exclusive.
    ])

  doc_attribute([set_zone_randomly])
    doc_text([
      Define an random zone for this terrain. This is used in maps like
      Archipelago to allow players to randomly spawn together or apart.

      doc_ref(zone), doc_ref(set_zone_randomly), and doc_ref(set_zone_by_team)
      are mutually exclusive.
    ])

  doc_attribute([set_zone_by_team])
    doc_text([
      Sets a zone for players based on their team. Allies will share the same
      land.

      doc_ref(zone), doc_ref(set_zone_randomly), and doc_ref(set_zone_by_team)
      are mutually exclusive.
    ])

  doc_attribute([other_zone_avoidance_distance], [N])
    doc_argument(N, Integer Tile Count, [0], [
      Defines a minimum distance from lands of other zones.

      This attribute only works if it is declared in both zones. If you give
      two lands different values, the smaller avoidance distance will be the
      one that applies
    ])

  doc_attribute([min_placement_distance], [N])
    doc_argument(N, Integer Tile Count, [0], [
      Specifies the minimum distance that a land's origin must be placed
      away from the origins of other lands.

      Has no effect when used on player lands.
    ])

  doc_attribute([land_id], [ID])
    doc_argument(ID, Integer Land Id, [], [
      Specified a land id number that can be used to target this land
      in the doc_ref(doc_pre([<OBJECTS_GENERATION>]), OBJECTS_GENERATION) phase.

      This will not work with lands created via doc_ref(create_player_lands),
      but it will work with lands that are made into player lands with
      doc_ref(assign_to_player).

      When multiple lands have the same id, create_object commands will
      create duplicate objects across all such lands.
    ])

  doc_attribute([assign_to_player], [PLAYER])
    doc_argument(PLAYER, Player Number (1..8), [], [
      Assigns this land to be a player land for the given player.

      If the player is not playing, the land will not be placed. Lands
      may only be assigned to a single player.

      When used with doc_ref(direct_placement), player lands can be placed in
      fixed locations with doc_ref(land_position).
    ])

  doc_attribute([circle_placement])
    doc_text([
      Enables circular placement mode, whereing players are placed in a
      ring around the outer edge of the map.

      Use with doc_ref(circle_radius) to control the radius of the circle.

      When this attribute is specified, doc_ref(border_fuzziness) can be used
      to introduce variation in the positioning of player lands.

      doc_strong([Note:]) left_border, right_border, bottom_border, top_border do not
      work when circle_placement is used.

      doc_strong([New in DE.])

      See the doc_link([Forgotten Empires site],
        [https://www.forgottenempires.net/age-of-empires-ii-definitive-edition/rms-features])
      for more information.
    ])

  doc_attribute([circle_radius], [%])
    doc_argument([%], [Integer Percent Radius (0..50)], [0], [
      Represents the distance from the center to player lands placed with
      doc_ref(circle_placement).
    ])
    doc_text([
      doc_strong([New in DE.])

      See the doc_link([Forgotten Empires site],
        [https://www.forgottenempires.net/age-of-empires-ii-definitive-edition/rms-features])
      for more information.
    ])
doc_category(ELEVATION_GENERATION)
doc_quote(TODO)

doc_category(TERRAIN_GENERATION)

  doc_command([create_terrain], [TYPE {...}])

  doc_command([color_correction], [TYPE])
    doc_argument(TYPE, Color Correction Constant, [], [
      Sets a specific color correction based on the season.

      Must be one of: doc_pre([CC_DESERT]), doc_pre([CC_JUNGLE]), doc_pre([CC_AUTUMN]), or doc_pre([CC_WINTER]).

      doc_strong([New in DE.])
    ])


  doc_attribute([base_terrain], [TYPE])
    doc_argument(TYPE, Terrain Constant, [GRASS], [
      Defines the terrain type that this terrain should replace.
    ])

  doc_attribute([land_percent], [%])

  doc_attribute([number_of_tiles], [N])

  doc_attribute([set_scale_by_size])

  doc_attribute([set_scale_by_groups])

  doc_attribute([spacing_to_other_terrain_types], [N])

  doc_attribute([height_limits], [LOWEST HIGHEST])

  doc_attribute([set_flat_terrain_only])

  doc_attribute([clumping_factor], [VALUE])
    doc_argument(VALUE, Integer (-100..99), [8], [
      Higher values here will cause clumps to prefer to spread to tiles
      closer to their origin, creating rounder areas.
    ])

  doc_attribute([terrain_mask], [LAYER])
    doc_argument(LAYER, doc_pre([1]) (overlay) or doc_pre([2]) (underlay), [], [
      Allows the terrain to be placed as an overlay or underlay of the
      existing terrain, rather than replacing it entirely. This can create
      unique visuals that were not possible in previous versions of the game.

      doc_strong([New in DE.])
    ])
