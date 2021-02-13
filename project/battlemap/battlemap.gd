extends TileGrid
# This extends our TileGrid class, so it can use it's functions natively.
# Place map-specific code here, like maybe spawn points.

func _ready():
	fabricate_map()
	print("Battlemap ready.")

	# Print our grid to show it has inherited the fabricated map correctly.
	#show_grid()


func show_grid() -> void:
	print("The Grid: :\n",  grid)
