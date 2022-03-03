GLOBAL_LIST_EMPTY(penguins)

#define ANIMATION_STATE_DANCE "dance"

/mob/living/basic/club_penguin
	name = "penguin"
	icon = 'modular_event/club_penguin/penguin/icons/penguin.dmi'
	appearance_flags = PIXEL_SCALE | TILE_BOUND | KEEP_TOGETHER
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	living_flags = NONE

	maptext_width = 256
	maptext_x = -112
	maptext_y = -8

	var/animation_state
	var/penguin_color
	var/list/equipped_clothing = list(/datum/club_penguin_clothing/miners_helmet)

/mob/living/basic/club_penguin/Initialize(mapload, name = "penguin", penguin_color = "#ff0000")
	. = ..()

	src.name = name
	src.penguin_color = penguin_color
	inventory = new

	GLOB.penguins += src

	update_appearance()

	create_nameplate()

/mob/living/basic/club_penguin/Destroy()
	GLOB.penguins -= src
	return ..()

/mob/living/basic/club_penguin/Moved()
	. = ..()

	if (!isnull(animation_state))
		animation_state = null
		update_appearance(UPDATE_OVERLAYS)

/mob/living/basic/club_penguin/proc/dance()
	animation_state = ANIMATION_STATE_DANCE
	update_appearance(UPDATE_OVERLAYS)

/mob/living/basic/club_penguin/update_overlays()
	. = ..()

	var/body_state = "penguin_body"
	var/features_state = "penguin_features"
	var/item_state = "item"

	// CP TODO: Throwing snowballs can't be a flick, since they can move to cancel it.
	// Change the dmi export to be a 0-loop animation
	switch (animation_state)
		if (ANIMATION_STATE_DANCE)
			body_state = "dance_body"
			features_state = "dance_features"
			item_state = "dance"

	var/image/penguin_body = image(icon, icon_state = body_state)
	penguin_body.color = penguin_color
	. += penguin_body

	. += image(icon, icon_state = features_state)
	. += inventory.create_penguin_overlays(item_state)

	return .

/mob/living/basic/club_penguin/proc/create_nameplate()
	maptext = {"<span style="font-family: 'Small Fonts'; font-size: 6px; color: #000; text-align: center">[name]</span>"}
