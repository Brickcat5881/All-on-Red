extends Node
@onready var fold_button: Button = $FoldButton
@onready var check_button: Button = $CheckButton
@onready var bet_button: Button = $BetButton
@onready var call_button: Button = $CallButton
@onready var button_clicks: AudioStreamPlayer2D = $ButtonClicks



const CALL_CLICKED = preload("res://assets/images/Game Buttons/callClicked.PNG")
const CALL_NOT_CLICKED = preload("res://assets/images/Game Buttons/callNotClicked.PNG")
const CHECK_CLICKED = preload("res://assets/images/Game Buttons/checkClicked.PNG")
const CHECK_NOT_CLICKED = preload("res://assets/images/Game Buttons/checkNotClicked.PNG")
const FOLD_CLICKED = preload("res://assets/images/Game Buttons/foldClicked.PNG")
const FOLD_NOT_CLICKED = preload("res://assets/images/Game Buttons/foldNotClicked.PNG")
const LEFT_CLICKED = preload("res://assets/images/Game Buttons/leftClicked.png")
const LEFT_NOT_CLICKED = preload("res://assets/images/Game Buttons/leftNotClicked.png")
const RIGHT_CLICKED = preload("res://assets/images/Game Buttons/rightClicked.png")
const RIGHT_NOT_CLICKED = preload("res://assets/images/Game Buttons/rightNotClicked.png")

const BUTTON_CLICK = preload("res://assets/audio/sfx/button_click.mp3")
const BUTTON_ENTER = preload("res://assets/audio/sfx/button_enter.mp3")
const BUTTON_EXIT = preload("res://assets/audio/sfx/button_exit.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_fold_button_mouse_entered() -> void:
	fold_button.icon = FOLD_CLICKED
	button_clicks.stream = BUTTON_ENTER
	button_clicks.play()
func _on_fold_button_mouse_exited() -> void:
	fold_button.icon = FOLD_NOT_CLICKED
	button_clicks.stream = BUTTON_EXIT
	button_clicks.play()
func _on_check_button_mouse_entered() -> void:
	check_button.icon = CHECK_CLICKED
	button_clicks.stream = BUTTON_ENTER
	button_clicks.play()
func _on_check_button_mouse_exited() -> void:
	check_button.icon = CHECK_NOT_CLICKED
	button_clicks.stream = BUTTON_EXIT
	button_clicks.play()
func _on_bet_button_mouse_entered() -> void:
	bet_button.icon = LEFT_CLICKED
	button_clicks.stream = BUTTON_ENTER
	button_clicks.play()
func _on_bet_button_mouse_exited() -> void:
	bet_button.icon = LEFT_NOT_CLICKED
	button_clicks.stream = BUTTON_EXIT
	button_clicks.play()
func _on_call_button_mouse_entered() -> void:
	call_button.icon = CALL_CLICKED
	button_clicks.stream = BUTTON_ENTER
	button_clicks.play()
func _on_call_button_mouse_exited() -> void:
	call_button.icon = CALL_NOT_CLICKED
	button_clicks.stream = BUTTON_EXIT
	button_clicks.play()

func _on_fold_button_pressed() -> void:
	button_clicks.stream = BUTTON_CLICK
	button_clicks.play()
func _on_check_button_pressed() -> void:
	button_clicks.stream = BUTTON_CLICK
	button_clicks.play()
func _on_bet_button_pressed() -> void:
	button_clicks.stream = BUTTON_CLICK
	button_clicks.play()
func _on_call_button_pressed() -> void:
	button_clicks.stream = BUTTON_CLICK
	button_clicks.play()
