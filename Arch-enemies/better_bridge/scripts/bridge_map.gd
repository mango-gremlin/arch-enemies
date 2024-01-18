extends TileMap

class_name BridgeMap
	
func get_tile_type(layer : int, pos : Vector2i):
	if get_cell_source_id(layer, pos) != -1: #check if there is a cell
		return get_cell_tile_data(layer,pos).get_custom_data("TILE_TYPE") as TileType.Variants
	return TileType.Variants.NONE
