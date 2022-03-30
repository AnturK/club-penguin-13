GLOBAL_DATUM_INIT(club_penguin_map_ui, /datum/club_penguin_map_ui, new)

/atom/movable/screen/club_penguin_hud_button/map
	name = "map"
	icon_state = "map"
	screen_loc = "SOUTH:10,WEST:10"

/atom/movable/screen/club_penguin_hud_button/map/Click(location, control, params)
	GLOB.club_penguin_map_ui.ui_interact(usr)

/atom/movable/screen/club_penguin_hud_button/map/MouseEntered(location, control, params)
	icon_state = "map_open"

/atom/movable/screen/club_penguin_hud_button/map/MouseExited(location, control, params)
	icon_state = "map"

/datum/club_penguin_map_ui

/datum/club_penguin_map_ui/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/penguin_map_ui)
	)

/datum/club_penguin_map_ui/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CpMap")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/club_penguin_map_ui/ui_status(mob/user, datum/ui_state/state)
	return UI_INTERACTIVE

/datum/club_penguin_map_ui/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return .

	switch (action)
		if ("teleport")
			var/location = params["location"]
			var/area_typepath = text2path("/area/club_penguin/[location]")

			if (isnull(area_typepath))
				CRASH("Club Penguin map: Area typepath '[location]' does not exist!")

			if (!(area_typepath in GLOB.areas_by_type))
				CRASH("Club Penguin map: Area typepath '[location]' is not a UNIQUE_AREA!")

			var/area/current_area = get_area(usr)
			if (current_area.type != area_typepath)
				usr.create_temporary_loading_screen()
				usr.forceMove(get_safe_turf_in_area(GLOB.areas_by_type[area_typepath]))

			ui.close()

	return FALSE

/datum/asset/simple/penguin_map_ui
	assets = list(
		"club-penguin-map.png" = 'modular_event/club_penguin/hud/icons/map.png',
	)
