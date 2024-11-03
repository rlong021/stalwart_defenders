extends TileMapLayer

var HP = 5
var allcells
var tilearray = []
var changeme

var modulated_cells:Dictionary

func _ready() -> void:
	changeme = null
	allcells = get_used_cells()
	tilearray.resize(allcells.size())
	tilearray.fill(HP)

func _process(delta: float) -> void:
	pass

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return modulated_cells.has(coords)

func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	tile_data.modulate = modulated_cells.get(coords, Color.WHITE)
	
func took_damage(Darray):
	changeme = Darray
	modulated_cells[Vector2i(Darray)] = Color.RED
	notify_runtime_tile_data_update()
	await get_tree().create_timer(0.5).timeout
	modulated_cells[Vector2i(Darray)] = Color.WHITE
	notify_runtime_tile_data_update()
