extends Node

@onready var player_object = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player_object.maingame = self
	load_config()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
var state_path = "user://fancy_shit.save"

# We only save the players position
# See https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
func load_config():
	if not FileAccess.file_exists(state_path):
		print("No configuration file exists. Creating one...")
		save_config()
		return
	
	print("Configuration found. Attempting to read...")
	print(state_path)
	var save = FileAccess.open(state_path, FileAccess.READ)
	
	while save.get_position() < save.get_length():
		var json_string = save.get_line()
		var json = JSON.new()
		
		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue


		var node_data = json.get_data()

		if node_data["name"] == "Player":
			var player = $Player
			var position_x = node_data["pos_x"]
			var position_y = node_data["pos_y"]
			player.position = Vector2(position_x,position_y )
			player.inventory = node_data["inventory"]
			
	print("Loading complete")
			
	
func save_config():
	print("Saving player stats to ", state_path)
	var save = FileAccess.open(state_path, FileAccess.WRITE)

	# Storing player data
	var player_state = player_object.saveState()
	
	print("Storing \"", player_state, "\" to ", state_path) 
	
	var json_string = JSON.stringify(player_state)
	save.store_line(json_string)
