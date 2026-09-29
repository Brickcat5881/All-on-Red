extends Node2D

@onready var background: Sprite2D = $background
@onready var hover_sound: AudioStreamPlayer2D = $Buttons/start_button/hoverSound
@onready var click_sound: AudioStreamPlayer2D = $Buttons/start_button/clickSound
@onready var fullscreen_button: CheckButton = $Buttons/fullscreenButton

const SETTINGS_HOVER = preload("res://assets/images/settings_hover.png")
const SETTINGS_PRESSED = preload("res://assets/images/settings_pressed.png")
const START_HOVER = preload("res://assets/images/start_hover.png")
const START_PRESSED = preload("res://assets/images/start_pressed.png")
const DEFAULT_BACKGROUND = preload("res://assets/images/default_background.png")
const BUTTON_CLICK = preload("res://assets/audio/sfx/buttonClick.mp3")
const BUTTON_HOVER = preload("res://assets/audio/sfx/buttonHover.mp3")

func _ready() -> void:
	fullscreen_button.button_pressed = ConfigFileHandler.load_settings("video")["fullscreen"]
	if MenuMusic.playing != true:
		MenuMusic.play()
func _on_start_button_pressed():
	background.texture = START_PRESSED
	click_sound.play()
	get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")
func _on_start_button_mouse_entered():
	background.texture = START_HOVER
	hover_sound.play()
func _on_start_button_mouse_exited():
	background.texture = DEFAULT_BACKGROUND
	hover_sound.play()
func _on_back_button_pressed():
	background.texture = SETTINGS_PRESSED
	click_sound.play()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
func _on_back_button_mouse_entered():
	background.texture = SETTINGS_HOVER
	hover_sound.play()
func _on_back_button_mouse_exited():
	background.texture = DEFAULT_BACKGROUND
	hover_sound.play()


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	ConfigFileHandler.save_settings("video","fullscreen", toggled_on)
