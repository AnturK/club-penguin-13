/area/train
	area_has_base_lighting = TRUE
	base_lighting_alpha = 255
	static_lighting = FALSE

	var/list/datum/looping_sound/looping_sounds = list()

/datum/looping_sound/train_loop
	mid_sounds = 'modular_event/winter_ball_2021/train/sound/train_loop.ogg'
	mid_length = 5.7 SECONDS
	volume = 10

/area/train/Initialize(mapload)
	. = ..()

	RegisterSignal(SStrain, COMSIG_TRAIN_SUBSYSTEM_STOP_CHANGED, .proc/on_stop_changed)

/area/train/proc/on_stop_changed()
	SIGNAL_HANDLER

	if (SStrain.is_moving())
		for (var/key in looping_sounds)
			var/datum/looping_sound/looping_sound = looping_sounds[key]
			looping_sound.start()
	else
		for (var/key in looping_sounds)
			var/datum/looping_sound/looping_sound = looping_sounds[key]
			looping_sound.stop()

/area/train/Entered(atom/movable/arrived, area/old_area)
	. = ..()

	if (arrived in looping_sounds)
		return

	if (!ismob(arrived))
		return

	looping_sounds[arrived] = new /datum/looping_sound/train_loop(
		arrived,
		/* start_immediately = */ SStrain.is_moving(),
		/* direct = */ TRUE,
	)

/area/train/Exited(atom/movable/gone, direction)
	. = ..()

	var/datum/looping_sound/looping_sound = looping_sounds[gone]
	if (!isnull(looping_sound))
		qdel(looping_sound)
		looping_sounds -= gone
