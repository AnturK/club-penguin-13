/datum/club_penguin_loading_screen
	var/atom/movable/screen/club_penguin_loading_image/loading_image
	var/mob/mob

/datum/club_penguin_loading_screen/New(mob/mob)
	src.mob = mob

	var/loading_image_type = pick(subtypesof(/atom/movable/screen/club_penguin_loading_image))
	loading_image = new loading_image_type

	update_loading_image()

	mob.overlay_club_penguin_background("loading")

	RegisterSignal(mob, COMSIG_MOB_LOGIN, .proc/on_mob_login)

/datum/club_penguin_loading_screen/Destroy(force, ...)
	mob.clear_fullscreen("loading", animated = FALSE)
	mob.client?.screen -= loading_image
	QDEL_NULL(loading_image)

	return ..()

/datum/club_penguin_loading_screen/proc/update_loading_image()
	mob.client?.screen += loading_image

/datum/club_penguin_loading_screen/proc/on_mob_login()
	SIGNAL_HANDLER

	update_loading_image()

/mob/proc/create_temporay_loading_screen(decay = 2.5 SECONDS)
	var/datum/club_penguin_loading_screen/loading_screen = new(src)
	QDEL_IN(loading_screen, decay)
