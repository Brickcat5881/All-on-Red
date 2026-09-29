extends Button
const NEW_GAME_BUTTON_HOVER = preload("res://assets/images/NewGameButtonHover.png")
const NEW_GAME_BUTTON_NOT_PRESSED = preload("res://assets/images/NewGameButtonNotPressed.png")
const NEW_GAME_BUTTON_PRESSED = preload("res://assets/images/NewGameButtonPressed.png")
@onready var new_game_texture: TextureRect = $"../NewGameTexture"
const BUTTON_CLICK = preload("res://assets/audio/sfx/button_click.mp3")
const BUTTON_ENTER = preload("res://assets/audio/sfx/button_enter.mp3")
const BUTTON_EXIT = preload("res://assets/audio/sfx/button_exit.mp3")

@onready var button_clicks: AudioStreamPlayer2D = $"../ChoiceUI/ButtonClicks"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered() -> void:
	new_game_texture.texture = NEW_GAME_BUTTON_HOVER
	button_clicks.stream = BUTTON_ENTER
	button_clicks.play()

func _on_mouse_exited() -> void:
	new_game_texture.texture = NEW_GAME_BUTTON_NOT_PRESSED
	button_clicks.stream = BUTTON_EXIT
	button_clicks.play()

func _on_pressed() -> void:
	new_game_texture.texture = NEW_GAME_BUTTON_PRESSED
	button_clicks.stream = BUTTON_CLICK
	button_clicks.play()
