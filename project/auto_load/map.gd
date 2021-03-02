extends Node
# Represents a grid with its size, the size of each cell in pixels, and some helper functions to
# calculate and convert coordinates.
# It's meant to be shared between game objects that need access to those values.

# Define the tile size and offset (center) position of our tiles.
const TILE_SIZE := Vector2(64, 64)
const OFFSET := TILE_SIZE/2

# Directions of cardinal tiles, clickwise from midnight
const DIR_N := Vector2(0, -1) # Could use Vector2.UP
const DIR_E := Vector2(1, 0) # Could use Vector2.RIGHT
const DIR_S := Vector2(0, 1) # Could use Vector2.DOWN
const DIR_W := Vector2(-1, 0) # Could use Vector2.LEFT
const CARDINAL := [DIR_N, DIR_E, DIR_S, DIR_W]

# The main properties of our map.
# Many of these are likely unneeded, but I'm a fan of forward preparedness.
var bounds: Rect2
var origin_x: int
var origin_y: int
var width: int
var height: int
var origins: Vector2
var size: Vector2
var all_tiles: Array

# Passed grid information from TileGrid class.
# Grid used here holds all our TileCell information.
# {Vector2: TileCell}
var grid: Dictionary


""" Setgets """


""" Public Functions """


func get_cell_at(tile: Vector2) -> TileCell:
	# Returns a TileCell from the given Vector2 location on the Cartesian grid.
	return grid[tile]


func get_adjacent_tiles(tile: Vector2) -> PoolVector2Array:
	# Returns Cartesian coordinates of all valid adjacent tiles in the cardinal directions.
	var tiles: PoolVector2Array = []

	for dir in CARDINAL:
		if is_within_bounds(tile + dir):
			tiles.append(tile + dir)

	return tiles


func map_position(grid_position: Vector2) -> Vector2:
	# Returns the position of a cell's center in pixels.
	return grid_position * TILE_SIZE + OFFSET


func grid_coordinates(map_position: Vector2) -> Vector2:
	# Returns the coordinates of the cell on the grid given a position on the map.
	return (map_position / TILE_SIZE).floor()


func is_within_bounds(coords: Vector2) -> bool:
	# Returns true if the cell coordinates are within the grid.
	# Note: This does not mean the cell is a valid movement tile.
	# Pathfinding / movement code should check for that.
	var outx := coords.x >= 0 and coords.x < size.x
	var outy := coords.y >= 0 and coords.y < size.y
	return outx and outy


func clamp(grid_position: Vector2) -> Vector2:
	# Forces the grid_position to stay within the grid's bounds.
	var out := grid_position
	out.x = clamp(out.x, 0, size.x - 1.0)
	out.y = clamp(out.y, 0, size.y - 1.0)
	return out
