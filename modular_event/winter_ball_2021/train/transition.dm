GLOBAL_VAR(train_origin)

/// Represents the transition from the train to the current stop
/obj/effect/landmark/from_train_to_stop_transition
	name = "from train to stop transition"
	icon = 'icons/obj/device.dmi'
	icon_state = "pinonfar"

/obj/effect/landmark/from_train_to_stop_transition/Initialize(mapload, create_more = TRUE)
	..()

	if (mapload && create_more)
		fill_with_more()

	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/from_train_to_stop_transition/LateInitialize()
	. = ..()
	update_to_current_stop()

/obj/effect/landmark/from_train_to_stop_transition/proc/update_to_current_stop()
	var/turf/landing_position = SStrain.find_landing_position()
	var/turf/train_origin = GLOB.train_origin

	var/turf/target = locate(
		landing_position.x + (x - train_origin.x),
		landing_position.y + (y - train_origin.y),
		landing_position.z,
	)

	var/turf/current_turf = get_turf(src)

	current_turf.AddComponent(/datum/component/turf_transition, target)

// This is needed to prevent you from seeing space if the transition effect is blocked from your view,
// like it would if we were using the mirage component.
/obj/effect/landmark/from_train_to_stop_transition/proc/fill_with_more()
	// + 3 just for some fudge
	var/range = world.view + 3

	var/turf/southwest = locate(clamp(x - (dir & WEST ? range : 0), 1, world.maxx), clamp(y - (dir & SOUTH ? range : 0), 1, world.maxy), z)
	var/turf/northeast = locate(clamp(x + (dir & EAST ? range : 0), 1, world.maxx), clamp(y + (dir & NORTH ? range : 0), 1, world.maxy), z)

	for(var/turf/turf in block(southwest, northeast))
		if (turf != loc)
			new /obj/effect/landmark/from_train_to_stop_transition(turf, /* create_more = */ FALSE)

/// Marks where the transition turfs will send you
/obj/effect/landmark/transition_train_origin
	name = "train origin"

/obj/effect/landmark/transition_train_origin/Initialize(mapload)
	. = ..()
	GLOB.train_origin = get_turf(src)

/// Will perform transitions from one turf to another, blocking the movable if
/// it cannot make the cross.
/// Similar to the mirage component, will create an illusion that the object is there,
/// simulating not only vis_contents, but also opacity.
/datum/component/turf_transition
	var/atom/movable/turf_transition_blocker/blocker
	var/turf/transition_to

/datum/component/turf_transition/Initialize(transition_to)
	. = ..()

	if (!isturf(parent))
		return COMPONENT_INCOMPATIBLE

	if (!isturf(transition_to))
		stack_trace("transition_to ([transition_to]) is not a turf!")
		return COMPONENT_INCOMPATIBLE

	src.transition_to = transition_to
	blocker = new(null, transition_to)

/datum/component/turf_transition/RegisterWithParent()
	blocker.forceMove(parent)
	RegisterSignal(parent, COMSIG_ATOM_ENTERED, .proc/on_atom_entered)

/datum/component/turf_transition/UnregisterFromParent()
	if (!isnull(blocker))
		blocker.moveToNullspace()
		blocker.vis_contents.Cut()
	UnregisterSignal(parent, COMSIG_ATOM_ENTERED)

/datum/component/turf_transition/Destroy(force, silent)
	QDEL_NULL(blocker)
	transition_to = null

	return ..()

/datum/component/turf_transition/proc/on_atom_entered(turf/source, atom/movable/arrived)
	SIGNAL_HANDLER
	arrived.zMove(target = transition_to, z_move_flags = ZMOVE_FLIGHT_FLAGS | ZMOVE_INCLUDE_PULLED)

/atom/movable/turf_transition_blocker
	anchored = TRUE
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/turf/watching

/atom/movable/turf_transition_blocker/Initialize(mapload, watching)
	. = ..()

	src.watching = watching
	vis_contents += watching

	RegisterSignal(watching, COMSIG_ATOM_ENTERED, .proc/on_entered)
	RegisterSignal(watching, COMSIG_ATOM_EXITED, .proc/on_exited)

	update_opacity()

/atom/movable/turf_transition_blocker/Destroy(force)
	watching = null

	return ..()

/atom/movable/turf_transition_blocker/CanPass(atom/movable/mover, border_dir)
	if (!..())
		return FALSE

	return !watching.is_blocked_turf()

/atom/movable/turf_transition_blocker/proc/update_opacity()
	if (watching.opacity)
		set_opacity(TRUE)
		return

	for (var/atom/movable/content as anything in watching.contents)
		if (content.opacity)
			set_opacity(TRUE)
			return

	set_opacity(FALSE)

/atom/movable/turf_transition_blocker/proc/on_entered(turf/source, atom/movable/arrived)
	SIGNAL_HANDLER
	if (arrived.opacity)
		set_opacity(TRUE)

/atom/movable/turf_transition_blocker/proc/on_exited(turf/source, atom/movable/arrived)
	SIGNAL_HANDLER
	update_opacity()
