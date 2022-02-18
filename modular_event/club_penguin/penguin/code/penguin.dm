/mob/living/basic/club_penguin
	name = "penguin"
	icon = 'modular_event/club_penguin/penguin/icons/penguin.dmi'
	living_flags = NONE

	var/penguin_color

/mob/living/basic/club_penguin/Initialize(mapload, penguin_color = "#f00")
	. = ..()

	src.penguin_color = penguin_color

	update_appearance()

// I don't think GAGS lets us specify pixel_y
/mob/living/basic/club_penguin/update_overlays()
	. = ..()

	var/image/penguin_body = image(icon, icon_state = "penguin_body")
	penguin_body.color = penguin_color
	penguin_body.pixel_y = 4
	. += penguin_body

	. += image(icon, icon_state = "penguin_features")

	return .
