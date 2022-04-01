/atom/movable/screen/club_penguin_hud_button/bottom
	icon = 'modular_event/club_penguin/hud/icons/hud_bottom.dmi'
	screen_loc = "SOUTH,CENTER-4:-8"

/atom/movable/screen/club_penguin_hud_button/bottom/bg
	icon_state = "bg"

/atom/movable/screen/club_penguin_hud_button/bottom/chat
	icon_state = "chat"

/atom/movable/screen/club_penguin_hud_button/bottom/chat/Click(location, control, params)
	usr.say_verb(input("Say") as text)

/atom/movable/screen/club_penguin_hud_button/bottom/actions
	icon_state = "actions"

	var/list/action_buttons
	var/mob/last_user

/atom/movable/screen/club_penguin_hud_button/bottom/actions/Destroy()
	clear_action_buttons(last_user)
	last_user = null

	return ..()

/atom/movable/screen/club_penguin_hud_button/bottom/actions/Click(location, control, params)
	if (isnull(action_buttons))
		action_buttons = create_club_penguin_actions_hud(usr, src)
		usr.client.screen += action_buttons
		last_user = usr
	else
		clear_action_buttons(usr)
		last_user = null

/atom/movable/screen/club_penguin_hud_button/bottom/actions/proc/clear_action_buttons(mob/user)
	user?.client.screen -= action_buttons
	QDEL_LIST(action_buttons)
	action_buttons = null

/atom/movable/screen/club_penguin_hud_button/bottom/actions/MouseEntered(location, control, params)
	icon_state = "actions_hovered"

/atom/movable/screen/club_penguin_hud_button/bottom/actions/MouseExited(location, control, params)
	icon_state = "actions"

/proc/create_club_penguin_bottom_hud(datum/hud/hud, mob/user)
	var/atom/movable/screen/club_penguin_hud_button/bottom/bg/bg = new(null, user)
	bg.hud = hud

	var/atom/movable/screen/club_penguin_hud_button/bottom/chat/chat = new(null, user)
	chat.layer = bg.layer + 1
	chat.hud = hud

	var/atom/movable/screen/club_penguin_hud_button/bottom/actions/actions = new(null, user)
	actions.layer = bg.layer + 1
	actions.hud = hud

	return list(bg, chat, actions)
