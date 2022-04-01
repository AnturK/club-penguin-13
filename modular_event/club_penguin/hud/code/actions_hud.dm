/atom/movable/screen/club_penguin_hud_button/actions
	icon = 'modular_event/club_penguin/hud/icons/hud_actions.dmi'
	screen_loc = "SOUTH+1:7,CENTER-4:-16"

/atom/movable/screen/club_penguin_hud_button/actions/bg
	icon_state = "bg"

/atom/movable/screen/club_penguin_hud_button/actions/dance
	icon_state = "dance"

	var/atom/movable/screen/club_penguin_hud_button/bottom/actions/actions

/atom/movable/screen/club_penguin_hud_button/actions/dance/Initialize(mapload, mob/owner, atom/movable/screen/club_penguin_hud_button/bottom/actions/actions)
	. = ..()

	src.actions = actions

/atom/movable/screen/club_penguin_hud_button/actions/dance/Destroy()
	actions = null
	return ..()

/atom/movable/screen/club_penguin_hud_button/actions/dance/Click(location, control, params)
	var/mob/living/basic/club_penguin/penguin = usr
	if (istype(penguin))
		penguin.dance()
	actions.clear_action_buttons(usr)

/atom/movable/screen/club_penguin_hud_button/actions/dance/MouseEntered(location, control, params)
	icon_state = "dance_hovered"

/atom/movable/screen/club_penguin_hud_button/actions/dance/MouseExited(location, control, params)
	icon_state = "dance"


/atom/movable/screen/club_penguin_hud_button/actions/joke
	icon_state = "joke"
	screen_loc = "SOUTH+3:9,CENTER-4:-16"

	var/atom/movable/screen/club_penguin_hud_button/bottom/actions/actions

/atom/movable/screen/club_penguin_hud_button/actions/joke/Initialize(mapload, mob/owner, atom/movable/screen/club_penguin_hud_button/bottom/actions/actions)
	. = ..()

	src.actions = actions

/atom/movable/screen/club_penguin_hud_button/actions/joke/Destroy()
	actions = null
	return ..()

/atom/movable/screen/club_penguin_hud_button/actions/joke/Click(location, control, params)
	var/mob/living/basic/club_penguin/penguin = usr
	if (istype(penguin))
		penguin.joke()
	actions.clear_action_buttons(usr)

/atom/movable/screen/club_penguin_hud_button/actions/joke/MouseEntered(location, control, params)
	icon_state = "joke_hovered"

/atom/movable/screen/club_penguin_hud_button/actions/joke/MouseExited(location, control, params)
	icon_state = "joke"

/proc/create_club_penguin_actions_hud(mob/user, atom/movable/screen/club_penguin_hud_button/bottom/actions/actions)
	var/atom/movable/screen/club_penguin_hud_button/actions/bg/bg = new(null, user)

	var/atom/movable/screen/club_penguin_hud_button/actions/dance/dance = new(null, user, actions)
	dance.layer = bg.layer + 1

	var/atom/movable/screen/club_penguin_hud_button/actions/bg/joke_bg = new(null, user)
	joke_bg.screen_loc = "SOUTH+3:9,CENTER-4:-16"

	var/atom/movable/screen/club_penguin_hud_button/actions/joke/joke = new(null, user, actions)
	joke.layer = bg.layer + 1

	return list(bg, dance, joke_bg, joke)
