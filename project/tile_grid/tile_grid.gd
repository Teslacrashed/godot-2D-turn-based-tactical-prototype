class_name TileGrid
extends TileMap

# This class handles the grid functions for manipulating TileMaps and TileCells.
# TileGrid uses Cartesian plane for coordinates.
# TileGrid uses Manhatten distance, so all cost are either 0 or 1.
# Strict nomenclature of variable names keeps concepts manageable across classes.
# Usage of "coords" refers to the Cartesian coordinates on the map.
# Usage of "tile" and "tiles" in variables / methods will refer to Vector2 Cartesian coordinates.
# Usage of "cell" and "cells" in variables / methods will refer to TileCells.

# Define the tile size and offset (center) position of our tiles.
const TILE_SIZE = Vector2(64,64)
const OFFSET = Vector2(32, 32)

# Directions of cardinal tiles, clickwise from midnight
const DIR_N = Vector2(0, -1)
const DIR_E = Vector2(1, 0)
const DIR_S = Vector2(0, 1)
const DIR_W = Vector2(-1, 0)
const DIR_CARDINAL = [DIR_N, DIR_E, DIR_S, DIR_W]

# Define an empty Pool Vector2 Array for easy returning in edge cases.
const EMPTY_VECTOR2_ARRAY = PoolVector2Array([])

# Grid used to create all TileCells.
# Allows easy retrieval of TileCells.
# {Vector2: TileCell}
var grid: Dictionary setget _set_grid, get_grid # Holds all TileCell data

# Properties used to ensure only valid locations are used to create the grid and cells.
# Many of these are likely unneeded, but I'm a fan of forward preparedness.
onready var bounds := get_used_rect()
onready var	origin_x = bounds.position.x
onready var origin_y = bounds.position.y
onready var width := bounds.end.x
onready var height := bounds.end.y
onready var origins = Vector2(origin_x, origin_y)
onready var size = Vector2(height, width)
onready var all_tiles := get_used_cells()


func _ready():
	print("TileGrid ready.")


""" Setgets """


func _set_grid(dict: Dictionary) -> void:
	grid = dict


func get_grid() -> Dictionary:
	return grid


"""
	Converting between Cartesian coordinates and our TileGrid.
"""

func obj_to_world_(coords):
	# Returns Cartesian coordinates of the given object on the tilemap.
	# Give any object that uses the tilemap a setget method for coordinates.
	if typeof(coords) == TYPE_VECTOR2:
		return map_to_world(coords)

	elif typeof(coords) == TYPE_OBJECT and coords.has_method("get_coordinates"):
		return map_to_world(coords.get_coordinates())

	# Fall through to nothing
	return


func obj_to_world_centered(coords):
	# Returns centered tilemap position of the given object.
	if typeof(coords) == TYPE_VECTOR2:
		return map_to_world(coords) + OFFSET

	elif typeof(coords) == TYPE_OBJECT and coords.has_method("get_coordinates"):
		return map_to_world(coords.get_coordinates()) + OFFSET

	# Fall through to nothing
	return


func get_cell_at(coords: Vector2) -> TileCell:
	# Returns a TileCell from the given Vector2 location on the Cartesian grid.
	# This is the primary way to access all our instanced TileCells.
	return grid[coords]


func get_all_adjacent(coords: Vector2) -> PoolVector2Array:
	# Returns Cartesian coordinates of all adjacent tiles in the cardinal directions.
	# Purpose is for pathfinding information mostly.
	var tiles: PoolVector2Array = []

	for dir in DIR_CARDINAL:
		tiles.append(coords + dir)

	return tiles


func fabricate_map() -> void:
	# All TileMaps should extend from TileGrid
	# So we expose this function to build the grid for any map loaded.
	_fabricate_map()


""" Private Functions """


func _fabricate_map() -> void:
	# Creates our grid dictionary.
	# Adds all information inside each TileCell instance.
	# Since this uses the map's used_rect, most tiles will be valid locations.

	for x in range(width):
		for y in range(height):
			var coords = Vector2(x, y)
			var center = map_to_world(coords) + OFFSET
			var id = _get_id_for_point(coords)
			var pos = map_to_world(coords)
			var rect = Rect2(pos, TILE_SIZE)
			grid[coords] = TileCell.new(center, coords, id, pos, rect)

	# Now that we have have grid of all tiles, let's go and add neighbors.
	for cell in grid.values():
		_add_grid_tile_neighbors(cell)


func _get_id_for_point(point : Vector2) :
	# Creates IDs used for AStar information.

	var x = point.x - bounds.position.x
	var y = point.y - bounds.position.y
	return x + y * bounds.size.x


func _is_valid_map_tile(coords: Vector2) -> bool:
	# Ensures coordinates are valid.
	# First see if the coordinate point exist in the TileMap's used Rect2.
	# Second check if the coordinates exist in the location of TileMap's used cells.
	# This is important for our add grid tile neighbors function, so it doesn't pull out of bounds tiles.

	if bounds.has_point(coords) and coords in all_tiles:
		return true

	else:
		return false


func _add_adjacent_tiles(coords: Vector2) -> PoolVector2Array:
	# Returns all adjacent tiles in the cardinal directions.

	var tiles: PoolVector2Array = []

	for dir in DIR_CARDINAL:
		if _is_valid_map_tile(dir):
			tiles.append(coords + dir)

	return tiles


func _add_grid_tile_neighbors(cell: TileCell) -> void:
	# Adds the neighboring TileCells to every cell in our grid.

	var cells: Array = []

	for dir in _add_adjacent_tiles(cell.get_coordinates()):
		if _is_valid_map_tile(dir):
			cells.append(grid[dir])

	cell.set_neighbors(cells)
