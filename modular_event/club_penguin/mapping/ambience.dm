/datum/controller/subsystem/ambience
	can_fire = FALSE

/obj/effect/landmark/area_ambience
	icon_state = "x4"
	var/ambience_to_play

/obj/effect/landmark/area_ambience/Initialize(mapload)
	. = ..()

	var/area/area = get_area(src)
	RegisterSignal(area, COMSIG_AREA_ENTERED, .proc/on_area_entered)
	RegisterSignal(area, COMSIG_AREA_EXITED, .proc/on_area_exited)

/obj/effect/landmark/area_ambience/proc/on_area_entered(datum/source, atom/movable/arrived)
	SIGNAL_HANDLER

	var/mob/arrived_mob = arrived
	if (!istype(arrived_mob))
		return

	RegisterSignal(arrived, COMSIG_MOB_LOGIN, .proc/on_mob_login)
	SEND_SOUND(arrived_mob, sound(ambience_to_play, repeat = TRUE, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE))

/obj/effect/landmark/area_ambience/proc/on_area_exited(datum/source, atom/movable/exited)
	SIGNAL_HANDLER

	var/mob/exited_mob = exited
	if (!istype(exited_mob))
		return

	SEND_SOUND(exited, sound(null, channel = CHANNEL_AMBIENCE))
	UnregisterSignal(exited, COMSIG_MOB_LOGIN)

/obj/effect/landmark/area_ambience/proc/on_mob_login(mob/source)
	SIGNAL_HANDLER

	SEND_SOUND(source, sound(ambience_to_play, repeat = TRUE, wait = 0, volume = 25, channel = CHANNEL_AMBIENCE))
