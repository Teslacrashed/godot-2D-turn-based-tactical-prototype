extends TileGrid

# This extends our TileGrid class, so it can use it's functions natively.
# Place map-specific code here, like maybe spawn points.

func _ready():
	fabricate_tile_grid()
	print("Battlemap ready.")
