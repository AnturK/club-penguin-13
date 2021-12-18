/// Will spawn smoke when the train lands
/obj/effect/landmark/train_smoke
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"

/obj/effect/landmark/train_smoke/Initialize(mapload)
	. = ..()

	RegisterSignal(SStrain, COMSIG_TRAIN_SUBSYSTEM_STOP_CHANGED, .proc/on_stop_changed)

/obj/effect/landmark/train_smoke/proc/on_stop_changed()
	SIGNAL_HANDLER

	var/turf/target = loc

	var/turf/landing_position = SStrain.find_landing_position()
	if (!isnull(landing_position))
		var/turf/train_origin = GLOB.train_origin

		target = locate(
			landing_position.x + (x - train_origin.x),
			landing_position.y + (y - train_origin.y),
			landing_position.z,
		)

	new /obj/effect/particle_effect/smoke/train_smoke(target)

/obj/effect/particle_effect/smoke/train_smoke
	lifetime = 2
