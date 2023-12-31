class_name TileGrid
extends TileMap

# This class handles the grid functions for manipulating TileMaps and TileCells.
# TileGrid uses Cartesian plane for coordinates.
# TileGrid uses Manhatten distance, so all cost are either 0 or 1.
# Strict nomenclature of variable names keeps concepts manageable across classes.
# Usage of "coords" refers to the Cartesian coordinates on the map.
# Usage of "tile" and "tiles" in variables / methods will refer to Vector2 Cartesian coordinates.
# Usage of "cell" and "cells" in variables / methods will refer to TileCells.
# TileGrid is used to formualte information from a TileMap, then send it to the Map Singleton.

# Define the tile size and offset (center) position of our tiles.
const TILE_SIZE = Vector2(64, 64)
const OFFSET = TILE_SIZE/2

# Directions of cardinal tiles, clickwise from midnight
const DIR_N = Vector2(0, -1) # Could use Vector2.UP
const DIR_E = Vector2(1, 0) # Could use Vector2.RIGHT
const DIR_S = Vector2(0, 1) # Could use Vector2.DOWN
const DIR_W = Vector2(-1, 0) # Could use Vector2.LEFT
const CARDINAL = [DIR_N, DIR_E, DIR_S, DIR_W]

# Grid used to create all TileCells.
# Allows easy retrieval of TileCells.
# {Vector2: TileCell}
var _grid: Dictionary: get = _get_grid, set = _set_grid # Holds all TileCell data

# Properties used to ensure only valid locations are used to create the grid and cells.
# Many of these are likely unneeded, but I'm a fan of forward preparedness.
@onready var _bounds: Rect2 = get_used_rect()
@onready var _origin_x: int = int(_bounds.position.x)
@onready var _origin_y: int = int(_bounds.position.y)
@onready var _width: int = int(_bounds.end.x)
@onready var _height: int = int(_bounds.end.y)
@onready var _origins := Vector2(_origin_x, _origin_y)
@onready var _size := Vector2(_width, _height)
@onready var _all_tiles: Array = get_used_cells(0)


func _ready():
	print("TileGrid ready.")


""" Setget functions """


func _set_grid(dict: Dictionary) -> void:
	_grid = dict


func _get_grid() -> Dictionary:
	return _grid


""" Public functions. """


func fabricate_tile_grid() -> void:
	# All TileMaps should extend from TileGrid
	# So we expose this function to build the grid for any map loaded.
	_fabricate_tile_grid()


""" Private Functions """


func _fabricate_tile_grid() -> void:
	# Creates our grid dictionary.
	# Adds all information inside each TileCell instance.
	# Since this uses the map's used_rect, most tiles will be valid locations.

	for x in range(_width):
		for y in range(_height):
			var coords = Vector2(x, y)
			var center = map_to_local(coords) + OFFSET
			var id = _get_id_for_point(coords)
			var pos = map_to_local(coords)
			var rect = Rect2(pos, TILE_SIZE)
			_grid[coords] = TileCell.new(center, coords, id, pos, rect)

	# Now that the grid has all TileCells.
	# Add the TileCell neighbors to every TileCell.
	for cell in _grid.values():
		_add_grid_tile_neighbors(cell)

	# Send all information to our Map Singleton.
	_fabricate_map()


func _fabricate_map() -> void:
	# Sends the final TileGrid information to the Map Singleton.
	Map.bounds = _bounds
	Map.origin_x = _origin_x
	Map.origin_y = _origin_y
	Map.width = _width
	Map.height = _height
	Map.origins = _origins
	Map.size = _size
	Map.all_tiles = _all_tiles
	Map.grid = _grid


func _get_id_for_point(point : Vector2) :
	# Creates IDs used for AStar information.
	# Pass tile coordinates in for 'point'.

	var x = point.x - _origin_x
	var y = point.y - _origin_y
	return x + y * _bounds.size.x


func _is_valid_map_tile(tile: Vector2) -> bool:
	# Ensures coordinates are valid.
	# First see if the coordinate point exist in the TileMap's used Rect2.
	# Second check if the coordinates exist in the location of TileMap's used cells.
	# This is important for our add grid tile neighbors function, so it doesn't pull out of bounds tiles.

	if _bounds.has_point(tile) and tile in _all_tiles:
		return true

	else:
		return false


func _get_adjacent_tiles(tile: Vector2) -> PackedVector2Array:
	# Returns all adjacent tiles in the cardinal directions of the passed tile.
	# Probably a better way to do this inside _add_grid_tile_neighbors.

	var tiles: PackedVector2Array = []

	for dir in CARDINAL:
		# Make sure tile is a valid location on map.
		# Ignores negative coordinates and TileMap cells of -1 (unused cells)
		if _is_valid_map_tile(dir):
			tiles.append(tile + dir)

	return tiles


func _add_grid_tile_neighbors(cell: TileCell) -> void:
	# Adds the neighboring TileCells to the passed TileCell.

	var cells: Array = []

	for dir in _get_adjacent_tiles(cell.get_coordinates()):
		if _is_valid_map_tile(dir):
			cells.append(_grid[dir])

	cell.set_neighbors(cells)
