/proc/create_penguin(name, penguin_color)
	// Try to spawn us in the same place as another penguin
	// CP TODO: Make sure this is an accessible area
	var/list/best_areas = list()

	for (var/mob/living/basic/club_penguin/other_penguin as anything in GLOB.penguins)
		best_areas |= get_area(other_penguin)

	var/chosen_turf

	if (best_areas.len)
		var/area = pick(best_areas)

		var/list/open_turfs = list()

		for (var/turf/open/open_turf in area)
			if (open_turf.is_blocked_turf(exclude_mobs = TRUE))
				open_turfs += open_turf

		if (open_turfs.len)
			chosen_turf = pick(open_turfs)

	if (isnull(chosen_turf))
		var/obj/effect/landmark/observer_start/backup = locate() in GLOB.landmarks_list
		chosen_turf = get_turf(backup)

	var/mob/living/basic/club_penguin/penguin = new(chosen_turf, name, penguin_color)
	. = penguin

	var/area/penguin_area = get_area(penguin)
	penguin_area.Entered(penguin, null)

	return .
