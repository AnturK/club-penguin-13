/// A list of tiles to throw you at when you fall off the train
GLOBAL_LIST_EMPTY(falling_off_points)

// EVENT TODO: This should have a sprite of like, moving snow or somethin'
/turf/open/floor/holofloor/road
	name = "road"
	icon_state = "titanium_white"
	can_atmos_pass = ATMOS_PASS_NO

/turf/open/floor/holofloor/road/Entered(atom/movable/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()

	var/obj/falling_off_point = pick(GLOB.falling_off_points)
	var/turf/turf = get_turf(falling_off_point)
	arrived.zMove(target = turf, z_move_flags = ZMOVE_FALL_FLAGS)
	turf.zImpact(arrived, 1, src)

/proc/get_on_the_move_tile()
	var/static/tile = null

	if (isnull(tile))
		var/datum/turf_reservation/reservation = SSmapping.RequestBlockReservation(1, 1)
		tile = new /turf/open/floor/holofloor/road(reservation.reserved_turfs[1])

	return tile

/// The area you are teleported to when you fall off the train
/obj/effect/landmark/falling_off_point
	name = "falling off point"

/obj/effect/landmark/falling_off_point/Initialize(mapload)
	. = ..()
	GLOB.falling_off_points += src

/obj/effect/landmark/falling_off_point/Destroy()
	GLOB.falling_off_points -= src
	return ..()
