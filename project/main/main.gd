extends Node2D

# Declare out instanced child scenes.
onready var battlemap := $Battlemap


func _ready():
	print("Main ready.")


func _unhandled_input(_event):

	# Add the tile's map position of approximately where the mouse cursor if pointing at.
	# TODO: This always crashed if I move south of the grid.
	# Having problems identifying the best fix.
	var current_coords = battlemap.world_to_map(get_global_mouse_position())

	# Now grab the current cell of our mouse clicks.
	var current_cell = battlemap.get_cell_at(current_coords)


	if Input.is_action_just_pressed("ui_accept"):
		print("Current coords: ", current_coords)

		# Print info from our cell
		print(current_cell.print_cell())
