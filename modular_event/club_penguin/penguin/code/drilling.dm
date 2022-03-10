// Next post gets JACKHAMMERED
/mob/living/basic/club_penguin
	var/list/drilling_vis_contents

/mob/living/basic/club_penguin/proc/should_be_drilling()
	return is_dancing() \
		&& equipped_clothing.len == 1 \
		&& equipped_clothing[1] == /datum/club_penguin_clothing/miners_helmet

/mob/living/basic/club_penguin/proc/create_drilling_overlays()
	if (!isnull(drilling_vis_contents))
		return

	drilling_vis_contents = list(
		new /obj/effect/overlay/drilling/body(null, penguin_color),
		new /obj/effect/overlay/drilling/features,
		new /obj/effect/overlay/drilling/drill,
	)

	vis_contents += drilling_vis_contents

/mob/living/basic/club_penguin/proc/clear_drilling_overlays()
	if (isnull(drilling_vis_contents))
		return

	QDEL_LIST(drilling_vis_contents)
	drilling_vis_contents = null

// Overlays cannot be flicked...so they have to be vis_contents...
// *eye twitch*
/obj/effect/overlay/drilling
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	// layer = ABOVE_MOB_LAYER
	appearance_flags = KEEP_APART
	vis_flags = VIS_INHERIT_PLANE | VIS_INHERIT_LAYER

/obj/effect/overlay/drilling/body
	icon = 'modular_event/club_penguin/penguin/icons/penguin.dmi'
	icon_state = "drill_loop_body"

/obj/effect/overlay/drilling/body/Initialize(mapload, penguin_color)
	. = ..()

	color = penguin_color
	flick("drill_begin_body", src)

/obj/effect/overlay/drilling/features
	icon = 'modular_event/club_penguin/penguin/icons/penguin.dmi'
	icon_state = "drill_loop_features"

/obj/effect/overlay/drilling/features/Initialize(mapload)
	. = ..()
	flick("drill_begin_features", src)

/obj/effect/overlay/drilling/drill
	icon = 'modular_event/club_penguin/inventory/icons/429.dmi'
	icon_state = "drill_loop"

/obj/effect/overlay/drilling/drill/Initialize(mapload)
	. = ..()
	flick("drill_begin", src)
