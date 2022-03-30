/atom/movable/screen/club_penguin_hud_button
	icon = 'modular_event/club_penguin/hud/icons/hud_buttons.dmi'

/atom/movable/screen/club_penguin_hud_button/Initialize(mapload, mob/owner)
	. = ..()

	RegisterSignal(owner, COMSIG_MOB_CLUB_PENGUIN_LOADING_SCREEN_STARTED, .proc/on_loading_screen_started)
	RegisterSignal(owner, COMSIG_MOB_CLUB_PENGUIN_LOADING_SCREEN_STOPPED, .proc/on_loading_screen_stopped)

/atom/movable/screen/club_penguin_hud_button/proc/on_loading_screen_started()
	SIGNAL_HANDLER
	invisibility = INVISIBILITY_MAXIMUM

/atom/movable/screen/club_penguin_hud_button/proc/on_loading_screen_stopped(mob/owner)
	SIGNAL_HANDLER
	invisibility = initial(invisibility)
