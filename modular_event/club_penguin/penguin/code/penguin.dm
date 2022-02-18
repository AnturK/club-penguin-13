/mob/living/basic/club_penguin
	name = "penguin"
	icon = 'modular_event/club_penguin/penguin/icons/penguin.dmi'
	living_flags = NONE

	maptext_width = 256
	maptext_x = -112
	maptext_y = -8

	var/penguin_color

/mob/living/basic/club_penguin/Initialize(mapload, name = "penguin", penguin_color = "#f00")
	. = ..()

	src.name = name
	src.penguin_color = penguin_color

	update_appearance()

	create_nameplate()

// I don't think GAGS lets us specify pixel_y
/mob/living/basic/club_penguin/update_overlays()
	. = ..()

	var/image/penguin_body = image(icon, icon_state = "penguin_body")
	penguin_body.color = penguin_color
	penguin_body.pixel_y = 4
	. += penguin_body

	. += image(icon, icon_state = "penguin_features")

	return .

/mob/living/basic/club_penguin/proc/create_nameplate()
	maptext = {"<span style="font-family: 'Small Fonts'; font-size: 6px; color: #000; text-align: center">[name]</span>"}
