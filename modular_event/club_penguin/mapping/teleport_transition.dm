/obj/effect/teleport_transition
	anchored = TRUE
	density = FALSE
	icon = 'icons/effects/mapping_helpers.dmi'
	icon_state = "airlock_cyclelink_helper"
	invisibility = INVISIBILITY_ABSTRACT

	var/club_penguin_area_type

/obj/effect/teleport_transition/Initialize(mapload)
	. = ..()

	var/turf/turf = get_turf(src)
	RegisterSignal(turf, COMSIG_ATOM_ENTERED, .proc/on_atom_entered)

	if (!(club_penguin_area_type in GLOB.areas_by_type))
		CRASH("[club_penguin_area_type] is not a UNIQUE_AREA!")

/obj/effect/teleport_transition/proc/on_atom_entered(turf/source, atom/movable/entered)
	SIGNAL_HANDLER

	if (ismob(entered))
		var/mob/entered_mob = entered
		entered_mob.create_temporary_loading_screen()
		entered.forceMove(get_safe_turf_in_area(GLOB.areas_by_type[club_penguin_area_type]))
