#define TIME_BEFORE_PULLING_UP_SOUND (6 SECONDS)
#define TIME_IN_TRANSIT (10 SECONDS)
#define TIME_PER_STOP (15 SECONDS)

#define WARN_PULL_UP_SOUND_PLAYED 1

/// The train will be stationed such that its origin will map onto this landmark.
/obj/effect/landmark/train_landing_position
	name = "train landing position"

SUBSYSTEM_DEF(train)
	name = "Event - Train"
	init_order = INIT_ORDER_MAPPING - 1
	runlevels = RUNLEVEL_GAME
	wait = 1 SECONDS

	var/datum/map_template/train_template
	var/list/datum/space_level/train_stops = list()

	// EVENT TODO: Make this the hyperspace equivalent
	var/current_stop

	var/current_stop_index = 0
	COOLDOWN_DECLARE(next_stop_cooldown)

	var/warning_level = 0

	var/list/train_stop_disposables = list()

	var/turf/landing_position

	var/first_fire = TRUE

/datum/controller/subsystem/train/stat_entry(msg)
	return ..("[msg] | Stop: [current_stop || "MOVING"] | Next Stop in [DisplayTimeText(next_stop_cooldown - world.time)]")

/datum/controller/subsystem/train/Initialize(start_timeofday)
	load_stops()
	load_falling_off_point()
	load_train()

	RegisterSignal(SSatoms, COMSIG_SUBSYSTEM_POST_INITIALIZE, .proc/on_post_atoms_init)

	return ..()

/datum/controller/subsystem/train/fire()
	if (first_fire)
		first_fire = FALSE
		COOLDOWN_START(src, next_stop_cooldown, TIME_IN_TRANSIT)

	if (!COOLDOWN_FINISHED(src, next_stop_cooldown))
		if (isnull(landing_position))
			warn_for_pulling_up()
		else
			warn_for_leaving()

		return

	if (isnull(landing_position))
		// We were in transit, so pick a new stop
		current_stop_index += 1
		COOLDOWN_START(src, next_stop_cooldown, TIME_PER_STOP)
		current_stop = train_stops[(current_stop_index % train_stops.len) + 1]

		// EVENT TODO: Cool UI effect, sounds, smoke, the whole shebang
		message_admins("The train is now at [current_stop].")
	else
		landing_position = null
		COOLDOWN_START(src, next_stop_cooldown, TIME_IN_TRANSIT)
		current_stop = null

		// EVENT TODO: The same shebang here
		message_admins("The train is now in transit.")

	SEND_SIGNAL(src, COMSIG_TRAIN_SUBSYSTEM_STOP_CHANGED)
	warning_level = 0

	update_train_at_stop()

/datum/controller/subsystem/train/proc/load_stops()
	for (var/datum/map_template/train_stop_template_type as anything in subtypesof(/datum/map_template/train_stop))
		var/datum/map_template/map_template = new train_stop_template_type
		train_stops[map_template.name] = map_template.load_new_z()

		CHECK_TICK

/datum/controller/subsystem/train/proc/find_landing_position()
	if (!isnull(landing_position))
		return landing_position

	if (isnull(current_stop))
		return null

	var/current_stop_z = train_stops[current_stop].z_value

	for (var/obj/effect/landmark/train_landing_position/possible_landing_position in GLOB.landmarks_list)
		if (possible_landing_position.z == current_stop_z)
			landing_position = get_turf(possible_landing_position)
			return landing_position

	CRASH("No valid landing position was found, is this being called before atoms SS?")

/datum/controller/subsystem/train/proc/load_train()
	train_template = new("_maps/winter_ball/train.dmm", "Train")
	train_template.load_new_z()

/datum/controller/subsystem/train/proc/load_falling_off_point()
	var/datum/map_template/falling_off_map = new("_maps/winter_ball/fell_off.dmm", "Falling Off Point")
	falling_off_map.load_new_z()

/datum/controller/subsystem/train/proc/on_post_atoms_init()
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, .proc/update_train_at_stop)

/datum/controller/subsystem/train/proc/update_train_at_stop()
	for (var/disposable in train_stop_disposables)
		qdel(disposable)
		CHECK_TICK

	train_stop_disposables.Cut()

	var/obj/landing_position = find_landing_position()
	if (isnull(landing_position))
		return

	var/turf/train_origin = GLOB.train_origin

	for (var/turf/train_turf in GLOB.areas_by_type[/area/train])
		var/turf/target = locate(
			landing_position.x + (train_turf.x - train_origin.x),
			landing_position.y + (train_turf.y - train_origin.y),
			landing_position.z,
		)

		train_stop_disposables += target.AddComponent(/datum/component/turf_transition, train_turf)

		CHECK_TICK

/datum/controller/subsystem/train/proc/warn_for_pulling_up()
	if (warning_level == WARN_PULL_UP_SOUND_PLAYED)
		return

	if (COOLDOWN_TIMELEFT(src, next_stop_cooldown) > TIME_BEFORE_PULLING_UP_SOUND)
		return

	warning_level = WARN_PULL_UP_SOUND_PLAYED

	for (var/mob/player_mob as anything in GLOB.player_list)
		if (istype(get_area(player_mob), /area/train))
			SEND_SOUND(player_mob, 'modular_event/winter_ball_2021/train/sound/train_pulling_up.ogg')

// EVENT TODO: Warn people, maybe over speakers in the area, the train is leaving soon?
/datum/controller/subsystem/train/proc/warn_for_leaving()

#undef TIME_BEFORE_PULLING_UP_SOUND
#undef TIME_IN_TRANSIT
#undef TIME_PER_STOP
#undef WARN_PULL_UP_SOUND_PLAYED
