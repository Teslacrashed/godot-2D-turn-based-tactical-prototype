class_name TileCell
extends Resource

# Class manages information for tiles on our tilemaps.
# Initialized from the TileGrid class.
# Then filled with scene-specific information.

# The strict size and offset (center) position of the TileCells.
const CELL_SIZE := Vector2(64, 64)
const OFFSET := Vector2(32, 32)

# Directions of Cartesian cardinal locations, clockwise from midnight.
const DIR_N := Vector2(0, -1)
const DIR_E := Vector2(1, 0)
const DIR_S := Vector2(0, 1)
const DIR_W := Vector2(-1, 0)
const DIR_CARDINAL := PoolVector2Array([DIR_N, DIR_E, DIR_S, DIR_W])

# The properties of TileCells.
var center: Vector2 setget set_center, get_center
var coordinates: Vector2 setget set_coordinates, get_coordinates
var id: int setget set_id, get_id
var neighbors: Array setget set_neighbors, get_neighbors
var position: Vector2 setget set_position, get_position
var rect: Rect2 setget set_rect, get_rect


func _init(_center: Vector2, _coords: Vector2, _id: int, _pos: Vector2, _rect: Rect2) -> void:
	# Create our TileCell.
	# We can't properly know neighbors when we first create a new TileCell.
	# So TileGrid will add the neighbors later.
	# Similarly you would have things like Units set later by other classes.

	set_center(_center)
	set_coordinates(_coords)
	set_id(_id)
	set_neighbors([])
	set_position(_pos)
	set_rect(_rect)


""" Setget Functions """


func set_center(_coords: Vector2) -> void:
	# Add the center of the TileCell for placing objects and moving them.
	# Most projects make a func in the TileMap class for this.
	# I think this is more elegant and requires less typing.
	# TileGrid class generates the proper center position and sends it here.
	center = _coords


func get_center() -> Vector2:
	return center


func set_coordinates(_coords: Vector2) -> void:
	# The Cartesian coordinates for the TileCell.
	coordinates = _coords


func get_coordinates() -> Vector2:
	return coordinates


func set_id(_id: int) -> void:
	# ID used for AStar pathfinding.
	# Starts at 0 in upper-left corner of the tilemap, incrementing across then down.
	id = _id


func get_id() -> int:
	return id


func set_neighbors(cells: Array) -> void:
	# Adds the neighbor cells in the cardinal directions.
	# cells are checked for valid TileMap locations in our TileGrid class.
	neighbors = cells


func get_neighbors() -> Array:
	return neighbors


func set_position(_pos: Vector2) -> void:
	# The upper-left position of a cell on the TileMap.
	# Unsure how useful this will be.
	position = _pos


func get_position() -> Vector2:
	return position


func set_rect(_rect: Rect2) -> void:
	# The rect2 area of a TileCell.
	# Used for _draw methods to highlight cells.
	rect = _rect


func get_rect() -> Rect2:
	return rect


""" Public Functions """


func print_cell() -> void:
	print("TileCell id: ", id, "\nTileCell coordinates: ", coordinates, "\nTileCell center: ", center,
			"\nTileCell neighbors: ", neighbors, "\nTileCell position: ", position, "\nTileCell rect: ", rect)
