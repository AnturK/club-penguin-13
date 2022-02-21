/atom/movable/screen/fullscreen/club_penguin_background
	icon = 'modular_event/club_penguin/menu/icons/bg.dmi'
	show_when_dead = TRUE
	screen_loc = "CENTER"

/atom/movable/screen/fullscreen/club_penguin_background/update_for_view(client_view)
	var/list/size = getviewsize(client_view)

	var/matrix/matrix = new
	matrix.Scale(size[1], size[2])
	transform = matrix

/mob/proc/overlay_club_penguin_background(category)
	overlay_fullscreen(category, /atom/movable/screen/fullscreen/club_penguin_background)

/atom/movable/screen/club_penguin_loading_image
	screen_loc = "CENTER"

/atom/movable/screen/club_penguin_loading_image/pizza
	icon = 'modular_event/club_penguin/menu/icons/pizza.dmi'
	plane = HUD_PLANE
	screen_loc = "CENTER:-82,CENTER:-40"
	pixel_x = -82
	pixel_y = -125
