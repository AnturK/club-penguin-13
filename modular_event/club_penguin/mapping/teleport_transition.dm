/obj/effect/landmark/teleport_transition
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "airlock_cyclelink_helper"

	var/club_penguin_area_type

/obj/effect/landmark/teleport_transition/Initialize(mapload)
	. = ..()

	var/turf/turf = get_turf(src)
	RegisterSignal(turf, COMSIG_ATOM_ENTERED, .proc/on_atom_entered)

	if (!(club_penguin_area_type in SScp_mapping.map_levels))
		CRASH("[club_penguin_map_type] is not a UNIQUE_AREA!")

/obj/effect/landmark/teleport_transition/proc/on_atom_entered(turf/source, atom/movable/entered)
	SIGNAL_HANDLER

	if (ismob(entered))
		entered.forceMove(get_safe_turf_in_area(GLOB.areas_by_type[club_penguin_area_type]))
