#define TIME_IN_TRANSIT (5 SECONDS)
#define TIME_PER_STOP (15 SECONDS)

/// The train will be stationed such that its origin will map onto this landmark.
/obj/effect/landmark/train_landing_position
	name = "train landing position"

SUBSYSTEM_DEF(train)
	name = "Event - Train"
	init_order = INIT_ORDER_MAPPING - 1
	wait = 5 SECONDS

	var/datum/map_template/train_template
	var/list/datum/space_level/train_stops = list()

	// EVENT TODO: Make this the hyperspace equivalent
	var/current_stop

	var/current_stop_index = 0
	var/time_left_for_stop = 0

	var/list/train_stop_disposables = list()

	var/turf/landing_position

/datum/controller/subsystem/train/stat_entry(msg)
	return ..("[msg] | Stop: [current_stop || "MOVING"]")

/datum/controller/subsystem/train/Initialize(start_timeofday)
	load_stops()
	load_falling_off_point()
	load_train()

	RegisterSignal(SSatoms, COMSIG_SUBSYSTEM_POST_INITIALIZE, .proc/on_post_atoms_init)

	return ..()

/datum/controller/subsystem/train/fire()
	time_left_for_stop -= wait

	// EVENT TODO: Warn people, maybe over speakers in the area, the train is leaving soon?
	if (time_left_for_stop > 0)
		return

	if (isnull(landing_position))
		// We were in transit, so pick a new stop
		current_stop_index += 1
		time_left_for_stop = TIME_PER_STOP
		current_stop = train_stops[(current_stop_index % train_stops.len) + 1]

		// EVENT TODO: Cool UI effect, sounds, smoke, the whole shebang
		message_admins("The train is now at [current_stop].")
	else
		landing_position = null
		time_left_for_stop = TIME_IN_TRANSIT
		current_stop = null

		// EVENT TODO: The same shebang here
		message_admins("The train is now in transit.")

	SEND_SIGNAL(src, COMSIG_TRAIN_SUBSYSTEM_STOP_CHANGED)

	update_train_at_stop()

/datum/controller/subsystem/train/proc/load_stops()
	var/stops_dir = "_maps/winter_ball/stops/"

	for (var/stop_file in flist(stops_dir))
		var/datum/map_template/map_template = new("[stops_dir][stop_file]", "[stop_file]")
		train_stops[stop_file] = map_template.load_new_z()

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

// EVENT TODO: Only clear, don't create, for hyperspace
/datum/controller/subsystem/train/proc/update_train_at_stop()
	QDEL_LIST(train_stop_disposables)
	CHECK_TICK

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

/datum/map_template/train_stop
	name = "Train Stop"

#undef TIME_IN_TRANSIT
#undef TIME_PER_STOP
