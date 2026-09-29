extends Node2D
@onready var background: Sprite2D = $"BackgroundStuff/background"
@onready var click_sound: AudioStreamPlayer2D = $Buttons/settings_button/clickSound
@onready var hover_sound: AudioStreamPlayer2D = $Buttons/settings_button/hoverSound
@onready var change_scene_wait_time: Timer = $BackgroundStuff/changeSceneWaitTime
@onready var exit_button: Button = $Buttons/exit_button

const SETTINGS_HOVER = preload("res://assets/images/settings_hover.png")
const SETTINGS_PRESSED = preload("res://assets/images/settings_pressed.png")
const START_HOVER = preload("res://assets/images/start_hover.png")
const START_PRESSED = preload("res://assets/images/start_pressed.png")
const DEFAULT_BACKGROUND = preload("res://assets/images/default_background.png")
const BUTTON_CLICK = preload("res://assets/audio/sfx/buttonClick.mp3")
const BUTTON_HOVER = preload("res://assets/audio/sfx/buttonHover.mp3")


# Called when the node enters the scene tree for the first time.
func _ready():
	background.texture = DEFAULT_BACKGROUND
	ResourceLoader.load_threaded_request("res://scenes/setting_menu.tscn")
	
	var masterBus = AudioServer.get_bus_index("Master")
	var musicBus = AudioServer.get_bus_index("BackgroundMusic")
	var effectBus = AudioServer.get_bus_index("QuiteEffects")
	var loadedValue = ConfigFileHandler.load_settings("audio")
	AudioServer.set_bus_volume_linear(masterBus,loadedValue["master"]/100)
	AudioServer.set_bus_volume_linear(musicBus,loadedValue["music"]/100)
	AudioServer.set_bus_volume_linear(effectBus,loadedValue["effects"]/100)
	var toggled_on = ConfigFileHandler.load_settings("video")
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	if MenuMusic.playing != true:
		MenuMusic.play()


func _on_start_button_pressed():
	background.texture = START_PRESSED
	click_sound.play()
	change_scene_wait_time.start()
	
func _on_start_button_mouse_entered():
	background.texture = START_HOVER
	hover_sound.play()
func _on_start_button_mouse_exited():
	background.texture = DEFAULT_BACKGROUND
	hover_sound.play()
func _on_settings_button_pressed():
	background.texture = SETTINGS_PRESSED
	click_sound.play()
	get_tree().change_scene_to_file("res://scenes/setting_menu.tscn")
func _on_settings_button_mouse_entered():
	background.texture = SETTINGS_HOVER
	hover_sound.play()
func _on_settings_button_mouse_exited():
	background.texture = DEFAULT_BACKGROUND
	hover_sound.play()


func _on_change_scene_wait_time_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")



func _on_exit_button_mouse_entered() -> void:
	exit_button.scale *=1.1


func _on_exit_button_mouse_exited() -> void:
	exit_button.scale /=1.1


func _on_exit_button_pressed() -> void:
	var currentData = MissionHandler.missionData
	currentData["progressData"]["handsWon"] = MissionHandler.handsWon
	currentData["progressData"]["handsPlayed"] = MissionHandler.handsPlayed
	MissionHandler.save_file(currentData)
	get_tree().quit()
