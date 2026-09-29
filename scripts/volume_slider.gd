extends VSlider

@onready var label: Label = $Label
@onready var sound_effect: AudioStreamPlayer2D = $SoundEffect
@onready var volume_slider_highlight: Sprite2D = $VolumeSliderHighlight

@export var poker_game_processing: Node

const CHIP1 = preload("res://assets/audio/sfx/Chips/201804__fartheststar__poker_chips4.wav")
const CHIP2 = preload("res://assets/audio/sfx/Chips/201805__fartheststar__poker_chips3.wav")
const CHIP3 = preload("res://assets/audio/sfx/Chips/201806__fartheststar__poker_chips2.wav")
const CHIP4 = preload("res://assets/audio/sfx/Chips/201807__fartheststar__poker_chips1.wav")
const CHIP5 = preload("res://assets/audio/sfx/Chips/201808__fartheststar__poker_chips6.wav")
const CHIP6 = preload("res://assets/audio/sfx/Chips/201809__fartheststar__poker_chips5.wav")

const maxScale = -0.485

var chipList = [CHIP1,CHIP2,CHIP3,CHIP4,CHIP5,CHIP6]
var valueRange = 100
var masterBus: int
var musicBus: int
var effectBus: int

func _ready() -> void:
	masterBus = AudioServer.get_bus_index("Master")
	musicBus = AudioServer.get_bus_index("BackgroundMusic")
	effectBus = AudioServer.get_bus_index("QuiteEffects")
	var loadedValues = ConfigFileHandler.load_settings("audio")
	var loadedValue: float
	if self.position.x == 2483.0:
		loadedValue = loadedValues["master"]
	elif self.position.x == 2789.0:
		loadedValue = loadedValues["music"]
	else:
		loadedValue = loadedValues["effects"]
	self.value = loadedValue
	_on_value_changed(loadedValue)
	
func _on_value_changed(sliderValue: float) -> void:
	label.text = str(int(sliderValue))+"%"
	label.position = Vector2(label.position.x,479-(value*4.6))
	volume_slider_highlight.scale = Vector2(volume_slider_highlight.scale.x,value*maxScale/100)
	if self.position.x == 2483.0:
		AudioServer.set_bus_volume_linear(masterBus,value/100)
		ConfigFileHandler.save_settings("audio","master",value)
	elif self.position.x == 2789.0:
		AudioServer.set_bus_volume_linear(musicBus,value/100)
		ConfigFileHandler.save_settings("audio","music",value)
	else:
		AudioServer.set_bus_volume_linear(effectBus,value/100)
		ConfigFileHandler.save_settings("audio","effects",value)
	sound_effect.stream = chipList[randi_range(0,5)]
	sound_effect.play()
	
