extends TileMap

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var width = 128
var height = 128
var half_width = width/2
var half_height = height/2
@onready var player = get_parent().get_child(1)

func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	altitude.frequency = 0.005


func _process(delta):
	generate_chunk(player.position)
	

func generate_chunk(position):
	var tile_pos = local_to_map(position)
	var player_offset_x = tile_pos.x-half_width
	var player_offset_y = tile_pos.y-half_height
	for x in range(width):
		var noise_pos_x = player_offset_x + x
		for y in range(height):
			var noise_pos_y = player_offset_y + y
			var moist = moisture.get_noise_2d(noise_pos_x,noise_pos_y)*10
			var temp = temperature.get_noise_2d(noise_pos_x,noise_pos_y)*10
			var alt = altitude.get_noise_2d(noise_pos_x, noise_pos_y)*10
			var temp_rand_tile = round((temp+10)/5)

			if alt < 2:
				set_cell(0, Vector2i(noise_pos_x, noise_pos_y), 0, Vector2(3, temp_rand_tile))
			else:
				set_cell(0, Vector2i(noise_pos_x, noise_pos_y), 0, Vector2(round((moist+10)/5), temp_rand_tile))
