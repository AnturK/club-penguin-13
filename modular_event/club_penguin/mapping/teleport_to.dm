/proc/get_safe_turf_in_area(area/area)
	var/list/open_turfs = list()
	var/list/open_turfs_with_mobs = list()

	for (var/turf/open/open_turf in area)
		if (open_turf.is_blocked_turf(exclude_mobs = TRUE))
			open_turfs += open_turf
		else if (open_turf.is_blocked_turf(exclude_mobs = FALSE))
			open_turfs_with_mobs += open_turf

	return pick(open_turfs) || pick(open_turfs_with_mobs) || (locate(/turf/open) in area)
