/proc/get_safe_turf_in_area(area/area)
	var/list/open_turfs = list()
	var/list/open_turfs_with_mobs = list()

	for (var/turf/open/open_turf in area)
		if (locate(/obj/effect/teleport_transition) in open_turf)
			continue

		if (!open_turf.is_blocked_turf(exclude_mobs = TRUE))
			open_turfs += open_turf
		else if (!open_turf.is_blocked_turf(exclude_mobs = FALSE))
			open_turfs_with_mobs += open_turf

	if (open_turfs.len > 0)
		return pick(open_turfs)

	stack_trace("open_turfs.len == 0 for [area]")

	if (open_turfs_with_mobs.len > 0)
		return pick(open_turfs_with_mobs)

	return locate(/turf/open) in area
