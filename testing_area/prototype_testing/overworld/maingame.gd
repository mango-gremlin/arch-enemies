extends Node

@onready var player_object = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	load_config()
	player_object.maingame = self
	
	select_profile("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# configuration and profiles section
var current_profile = "default"
var profiles:Array = ["default"]
var state_path = "user://arch-enemies.json"

# See https://docs.godotengine.org/en/stable/tutorials/io/saving_games.html
func load_config():
	if not FileAccess.file_exists(state_path):
		print("No configuration file exists. Creating one...")
		save_config()
		return
	
	print("Configuration found. Attempting to read...")
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

		if node_data["name"] == "Player" and node_data["profile"] == current_profile:
			print("Loading player state for profile \"" + current_profile + "\"")
			
			var player = $Player
			var position_x = node_data["pos_x"]
			var position_y = node_data["pos_y"]
			
			player.position = Vector2(position_x, position_y)
			
			#player.inventory = generate_inventory(node_data["inventory"])
			
			var camera2D = $Player/Camera2D
			camera2D._set_current_zoom(node_data["zoom"])
			
		if node_data["name"] == "Profiles":
			profiles = node_data["profiles"]
			
	print("Loading complete")
			
	
func generate_inventory(inventory_data):
	print(inventory_data)
	# iterate over each item and generate an item from each 
	return []
	

func save_config():
	var oldPlayers = []
	
	# extract OLD player profiles (e.g. with other profile names)
	if FileAccess.file_exists(state_path):
		var save = FileAccess.open(state_path, FileAccess.READ)
	
		while save.get_position() < save.get_length():
			var json_string = save.get_line()
			var json = JSON.new()
			
			var parse_result = json.parse(json_string)
			var node_data = json.get_data()

			if node_data["name"] == "Player":
				if node_data["profile"] == current_profile:
					continue
				
				oldPlayers.append(json_string)
	
	print("Saving configuration to ", state_path)
	var save = FileAccess.open(state_path, FileAccess.WRITE)

	# Storing THE CURRENT player data
	var player_state = player_object.saveState()
	player_state["profile"] = current_profile
	
	print("Storing player state \"", player_state, " ...") 
	
	var player_json_string = JSON.stringify(player_state)
	save.store_line(player_json_string)
	
	for oldPlayer in oldPlayers:
		save.store_line(oldPlayer)
	
	# Storing the profiles
	var profiles_data = {
		"name" : "Profiles",
		"profiles" : profiles
	}
	
	print("Storing profile data \"", profiles_data, "\"")
	
	var profiles_json_string = JSON.stringify(profiles_data)
	save.store_line(profiles_json_string)
	

# on success returns true
func create_profile(name):
	if name in profiles:
		print("profile does \"" + name + "\" already exist!")
		return false
	
	profiles.append(name)
	print("Created profile \"" + name + "\"!")
	save_config()
	return true

# on success returns true
func select_profile(name):
	if name not in profiles:
		print("profile \"" + name + "\" does not exist.")
		return false
	
	print("Selected profile \"", name, "\"")
	current_profile = name
	load_config()
	return true
