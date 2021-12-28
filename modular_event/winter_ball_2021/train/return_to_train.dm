/datum/action/cooldown/return_to_train
	name = "Return to Train"
	// EVENT TODO: Icon
	// icon_icon = 'modular_event/base/event_aheal/icons/button.dmi'
	// button_icon_state = "arena_heal"
	cooldown_time = 30 SECONDS

/datum/action/cooldown/return_to_train/Trigger()
	var/mob/living/user = usr

	. = ..()
	if (!.)
		return FALSE

	var/list/train_turfs = get_area_turfs(/area/train)
	var/turf/teleport_turf

	while (train_turfs.len)
		teleport_turf = pick_n_take(train_turfs)
		if (!isgroundlessturf(teleport_turf) && !teleport_turf.is_blocked_turf())
			break

	user.Immobilize(3 SECONDS)

	podspawn(list(
		"target" = get_turf(user),
		"path" = /obj/structure/closet/supplypod/back_to_train,
		"reverse_dropoff_coords" = list(teleport_turf.x, teleport_turf.y, teleport_turf.z),
		"trying_to_pick_up" = user,
	))

	StartCooldown()

/obj/structure/closet/supplypod/back_to_train
	reversing = TRUE

	style = STYLE_BLUE
	delays = list(
		POD_TRANSIT = 0.5 SECONDS,
		POD_OPENING = 0.8 SECONDS,
		POD_LEAVING = 0.8 SECONDS,
	)

	custom_rev_delay = TRUE
	reverse_delays = list(
		POD_TRANSIT = 1.5 SECONDS,
		POD_OPENING = 0.8 SECONDS,
		POD_LEAVING = 0.8 SECONDS,
	)

	explosionSize = list(0, 0, 0, 0)

	var/atom/trying_to_pick_up

/obj/structure/closet/supplypod/back_to_train/Destroy()
	trying_to_pick_up = null
	return ..()

/obj/structure/closet/supplypod/back_to_train/insertion_allowed(atom/to_insert)
	to_chat(world, "[to_insert]/[trying_to_pick_up]")
	return to_insert == trying_to_pick_up

/mob/living
	var/datum/action/cooldown/return_to_train/return_to_train_action = new

/mob/living/Destroy()
	return_to_train_action.Remove(src)
	QDEL_NULL(return_to_train_action)
	return ..()

/mob/living/Login()
	. = ..()
	return_to_train_action.Grant(src)

/mob/living/Logout()
	. = ..()

	if(isnull(return_to_train_action))
		return

	return_to_train_action.Remove(src)

