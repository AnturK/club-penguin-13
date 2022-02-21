/atom/movable/screen/club_penguin_logo
	icon = 'modular_event/club_penguin/menu/icons/logo.dmi'
	screen_loc = "CENTER:-204,CENTER+2:-70"

/atom/movable/screen/club_penguin_start
	icon = 'modular_event/club_penguin/menu/icons/start.dmi'
	icon_state = "start"
	screen_loc = "CENTER:-105,CENTER-4:-33"
	var/creating_penguin = FALSE

/atom/movable/screen/club_penguin_start/MouseEntered(location, control, params)
	icon_state = "start-hover"

/atom/movable/screen/club_penguin_start/MouseExited(location, control, params)
	icon_state = "start"

/atom/movable/screen/club_penguin_start/Click(location, control, params)
	if (creating_penguin)
		return

	creating_penguin = TRUE
	create_penguin_menu()
	creating_penguin = FALSE

/atom/movable/screen/club_penguin_start/proc/create_penguin_menu()
	var/color = input("Choose a color for your penguin.", "Penguin Color", "#[random_color()]") as color | null
	if (!color)
		return

	var/name = tgui_input_text(
		usr,
		"Choose a name for your penguin",
		"Penguin Name",
		usr.client.prefs.read_preference(/datum/preference/name/real_name),
		max_length = MAX_NAME_LEN,
	)

	if (!name)
		return

	var/mob/dead/new_player/new_player = usr

	var/mob/living/basic/club_penguin/penguin = create_penguin(name, color)
	penguin.key = usr.key

	qdel(src)
	qdel(new_player)

/mob/dead/new_player
	hud_type = /datum/hud/home_menu

/datum/hud/home_menu
	var/list/contents = list()

/datum/hud/home_menu/New(mob/owner)
	..()

	update_static_inventory()

	RegisterSignal(SSticker, COMSIG_TICKER_ENTER_PREGAME, .proc/on_enter_pregame)

	owner.overlay_club_penguin_background("home_menu")

/datum/hud/home_menu/Destroy(force, ...)
	mymob.clear_fullscreen("home_menu")
	QDEL_LIST(contents)
	return ..()

/datum/hud/home_menu/proc/update_static_inventory()
	static_inventory -= contents
	QDEL_LIST(contents)

	if (isnull(Master.current_initializing_subsystem))
		contents += new /atom/movable/screen/club_penguin_logo
		contents += new /atom/movable/screen/club_penguin_start
	else
		contents += new /atom/movable/screen/club_penguin_loading_image/pizza

	static_inventory += contents

/datum/hud/home_menu/proc/on_enter_pregame()
	SIGNAL_HANDLER

	update_static_inventory()
	show_hud(hud_version)

// This overrides everything, and we'll never use it
/turf/closed/indestructible/splashscreen
	invisibility = INVISIBILITY_MAXIMUM
