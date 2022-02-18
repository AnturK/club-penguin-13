SUBSYSTEM_DEF(cp_mapping)
	name = "Club Penguin - Mapping"
	init_order = INIT_ORDER_MAPPING
	flags = SS_NO_FIRE

	var/list/map_levels

/datum/controller/subsystem/cp_mapping/Initialize(start_timeofday)
	map_levels = list()

	for (var/club_penguin_map_type as anything in subtypesof(/datum/map_template/club_penguin_map))
		var/datum/map_template/club_penguin_map/club_penguin_map = new club_penguin_map_type
		var/datum/space_level/level = club_penguin_map.load_new_z()
		// Prevents some runtimes, not sure what else this effects
		level.traits[ZTRAIT_STATION] = TRUE
		map_levels[club_penguin_map_type] = level

		CHECK_TICK

	return ..()
