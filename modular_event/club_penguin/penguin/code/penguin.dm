/mob/living/basic/club_penguin
	name = "penguin"
	icon = 'modular_event/club_penguin/penguin/icons/penguin.dmi'
	appearance_flags = PIXEL_SCALE | TILE_BOUND | KEEP_TOGETHER
	living_flags = NONE

	maptext_width = 256
	maptext_x = -112
	maptext_y = -8

	var/dancing = FALSE
	var/penguin_color
	var/list/equipped_clothing = list(/datum/club_penguin_clothing/miners_helmet)

/mob/living/basic/club_penguin/Initialize(mapload, name = "penguin", penguin_color = "#ff0000")
	. = ..()

	src.name = name
	src.penguin_color = penguin_color

	update_appearance()

	create_nameplate()

/mob/living/basic/club_penguin/Moved()
	. = ..()

	if (dancing)
		dancing = FALSE
		update_appearance(UPDATE_OVERLAYS)

/mob/living/basic/club_penguin/proc/dance()
	dancing = TRUE
	update_appearance(UPDATE_OVERLAYS)

// I don't think GAGS lets us specify pixel_y
/mob/living/basic/club_penguin/update_overlays()
	. = ..()

	var/body_state = "penguin_body"
	var/features_state = "penguin_features"
	var/show_clothing = TRUE

	if (dancing)
		body_state = "dance_body"
		features_state = "dance_features"
		show_clothing = FALSE

	var/image/penguin_body = image(icon, icon_state = body_state)
	penguin_body.color = penguin_color
	penguin_body.pixel_y = 4
	. += penguin_body

	. += image(icon, icon_state = features_state)

	if (show_clothing)
		for (var/clothing_type as anything in equipped_clothing)
			var/datum/club_penguin_clothing/clothing = GLOB.club_penguin_clothing[clothing_type]

			var/image/clothing_image = image(clothing.icon, icon_state = "item")
			clothing_image.pixel_y = clothing.pixel_y
			. += clothing_image

	return .

/mob/living/basic/club_penguin/proc/create_nameplate()
	maptext = {"<span style="font-family: 'Small Fonts'; font-size: 6px; color: #000; text-align: center">[name]</span>"}
