extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
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
			print("Wir laden den Spieler!")
			var player = $Player
			player.position = Vector2(node_data["pos_x"], node_data["pos_y"])
			player.inventory = node_data["inventory"]
			
	print("Loading complete")
			
	
func save_config():
	print("Saving player stats to ", state_path)
	var save = FileAccess.open(state_path, FileAccess.WRITE)

	# Storing player data
	var p = $Player
	var pState = p.saveState()
	
	print("Storing \"", pState, "\" to ", state_path) 
	
	var json_string = JSON.stringify(pState)
	save.store_line(json_string)
