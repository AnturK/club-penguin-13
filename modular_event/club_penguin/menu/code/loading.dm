/datum/club_penguin_loading_screen
	var/atom/movable/screen/club_penguin_loading_image/loading_image
	var/mob/mob
	var/id

/datum/club_penguin_loading_screen/New(mob/mob)
	src.mob = mob

	id = rand()

	var/loading_image_type = pick(subtypesof(/atom/movable/screen/club_penguin_loading_image))
	loading_image = new loading_image_type

	update_loading_image()

	mob.overlay_club_penguin_background("loading_[id]")

	RegisterSignal(mob, COMSIG_MOB_LOGIN, .proc/on_mob_login)
	SEND_SIGNAL(mob, COMSIG_MOB_CLUB_PENGUIN_LOADING_SCREEN_STARTED)

/datum/club_penguin_loading_screen/Destroy(force, ...)
	mob.clear_fullscreen("loading_[id]", animated = FALSE)
	mob.client?.screen -= loading_image
	QDEL_NULL(loading_image)
	SEND_SIGNAL(mob, COMSIG_MOB_CLUB_PENGUIN_LOADING_SCREEN_STOPPED)

	return ..()

/datum/club_penguin_loading_screen/proc/update_loading_image()
	mob.client?.screen += loading_image

/datum/club_penguin_loading_screen/proc/on_mob_login()
	SIGNAL_HANDLER

	update_loading_image()

/mob/proc/create_temporary_loading_screen(decay)
	var/datum/club_penguin_loading_screen/loading_screen = new(src)
	QDEL_IN(loading_screen, decay || rand(1.5 SECONDS, 3.5 SECONDS))
