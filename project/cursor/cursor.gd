extends Node2D

# Cursor is what handles our mouse movement code.
# Can be ajusted easily for keyboard/controller buttons.

# Time before the cursor can move again in seconds.
export var ui_cooldown: float = 0.1

# Coordinates of the current tile the cursor is hovering.
var tile = Vector2.ZERO setget _set_tile

# Hold the cell the mouse cursor is hovering over.
# Can be used to send information to things like UI elements.
var _hovered_cell: TileCell setget _set_hovered_cell

# Selected cell for gameplay actions and UI components.
# Used to give information to things like unit movement classes.
var _selected_cell: TileCell

# This holds our previous cell for special circumstances.
# Could have cancel shift the camera back to previous cell.
var _previous_cell: TileCell

onready var _timer: Timer = $Timer


func _ready():
	position = Map.map_position(tile)
	_timer.wait_time = ui_cooldown
	print("Cursor ready")


func _unhandled_input(event: InputEvent):
	# Add the tile's map position of approximately where the mouse cursor if pointing at.

	# Connecting tile coordinates to mouse position.
	if event is InputEventMouseMotion:
		self.tile = Map.grid_coordinates(event.position)

	if Input.is_action_just_pressed("ui_accept"):
		_handle_selection()

	if Input.is_action_just_pressed("ui_cancel"):
		_handle_cancellation()


"""
	Setget functions
"""


func _set_tile(coords: Vector2) -> void:
	# Handles the conversation from world pixel position to TileMap Cartesian coordinates.
	if not Map.is_within_bounds(coords):
		# Ensure the cursor tile stays on the map.
		tile = Map.clamp(coords)
		_set_hovered_cell(Map.get_cell_at(tile))
	else:
		tile = coords
		_set_hovered_cell(Map.get_cell_at(tile))
	position = Map.map_position(tile)
	_timer.start()


""" Public Functions """


""" Private Functions """


func _set_hovered_cell(cell: TileCell) -> void:
	# Only change if cursor in a new cell's area.
	# This should avoid UI elements being constantly re-drawn later.
	if _hovered_cell != cell:
		_hovered_cell = cell


func _handle_selection() -> void:
	_selected_cell = _hovered_cell
	print("selected cell: ", _selected_cell)
	print(_selected_cell.print_cell())


func _handle_cancellation() -> void:
	_selected_cell = null
	print("cell cancelled: ", _selected_cell)
