/area/club_penguin/Entered(atom/movable/arrived, area/old_area)
	. = ..()

	if (lock_camera && ismob(arrived))
		update_camera(arrived)

/area/club_penguin/proc/update_camera(mob/mob)
	var/client/arrived_client = mob.client

	if (!isnull(arrived_client))
		arrived_client?.perspective = EDGE_PERSPECTIVE
		arrived_client?.edge_limit = "[corner1.x],[corner1.y] to [corner2.x],[corner2.y]"

		// Everything in view sizes is done as *offsets* of the default. Weird, huh?
		arrived_client?.view_size?.setDefault("[corner2.x - corner1.x + 1]x[corner2.y - corner1.y + 1]")
		arrived_client?.view_size?.resetToDefault()

// We need to override this because not everything calls area/Entered, such as observers
/mob/Moved(atom/OldLoc, Dir)
	. = ..()

	var/area/old_area = get_area(OldLoc)
	var/area/club_penguin/new_area = get_area(src)

	if (old_area != new_area && istype(new_area))
		new_area.update_camera(src)

/mob/Login()
	. = ..()

	var/area/club_penguin/new_area = get_area(src)
	if (istype(new_area))
		new_area.update_camera(src)

/mob/reset_perspective(atom/new_eye)
	. = ..()

	if (!client)
		return

	var/area/club_penguin/club_penguin_area = get_area(src)
	if (istype(club_penguin_area) && club_penguin_area.lock_camera)
		client?.perspective = EDGE_PERSPECTIVE

/obj/effect/landmark/club_penguin_corner1

/obj/effect/landmark/club_penguin_corner1/Initialize(mapload)
	. = ..()

	var/area/club_penguin/club_penguin_area = get_area(src)
	if (!istype(club_penguin_area))
		CRASH("club_penguin_corner1 was not in a Club Penguin area ([club_penguin_area])")

	club_penguin_area.corner1 = get_turf(src)

/obj/effect/landmark/club_penguin_corner2

/obj/effect/landmark/club_penguin_corner2/Initialize(mapload)
	. = ..()

	var/area/club_penguin/club_penguin_area = get_area(src)
	if (!istype(club_penguin_area))
		CRASH("club_penguin_corner2 was not in a Club Penguin area ([club_penguin_area])")

	club_penguin_area.corner2 = get_turf(src)
