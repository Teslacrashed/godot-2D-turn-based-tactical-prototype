# godot-2D-turn-based-tactical-prototype
 A 2D turn-based, tactical prototype game made in Godot.

## Project Information
 This project assumes you're using a standard square-based TileMap grid, although it can be fairly easily converted to work with Hexes or Isometric squares.

 It does not work with any tile positions that are negative, although this too is fixable through code, I prefer not to have negative coordinates because it means a lot of unnecessary code bloat and uglyness to handle the conversion math. Some range functions in the TileGrid class will need code added to allow for negative integers to be used.

### TileGrid
 This class extends TileMap and is only used to build your map information and TileCells. Your TileMap should extend from TileGrid, and then call it's fabricate_tile_grid() function and it will grab all relevant information.

### TileCell
 This class is used to create resource nodes for every tile on your map. These work very well for holding information like the TileCells location, ID's for AStar navigation, and information like if the TileCell is occupied by a unit. 

### Map
 This is an AutoLoad Singleton class that holds all map information so it's easily accessible by any node necessary. UI components, pathfinding, etc.

### Cursor
 This is a simple basic cursor node to follow your mouse and help retrieve TileCell information. Expand on it to perform actions like selecting and moving units or sending information about the hovered cells to UI components.
