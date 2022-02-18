// Cordons don't stop observers. I want them to.
/turf/cordon/Enter(atom/movable/mover)
	return FALSE

/mob/dead/observer/Move(NewLoc, direct, glide_size_override)
	if (istype(NewLoc, /turf/cordon))
		return

	return ..()
