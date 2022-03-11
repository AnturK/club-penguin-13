/turf/cordon
	// Overrides so that the backdrops (placed in the corners) will go through
	alpha = 0
	invisibility = 0

/turf/cordon/Initialize(mapload)
	. = ..()

	// Override here so that map editor can see cordons higher
	plane = TRANSPARENT_FLOOR_PLANE

// Cordons don't stop observers. I want them to.
/turf/cordon/Enter(atom/movable/mover)
	return FALSE

/mob/dead/observer/Move(NewLoc, direct, glide_size_override)
	if (istype(NewLoc, /turf/cordon))
		return

	return ..()
