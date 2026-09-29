extends Control
@onready var progress_bar: ProgressBar = $ProgressBar


var next_scene = "res://scenes/main_game.tscn"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene)
	MenuMusic.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	var progress = []
	ResourceLoader.load_threaded_get_status(next_scene,progress)
	progress_bar.value = progress[0]*100
	if progress[0] == 1:
		get_tree().change_scene_to_file(next_scene)
	
