extends VSlider

@onready var label: Label = $Label
@onready var sound_effect: AudioStreamPlayer2D = $SoundEffect

@export var poker_game_processing: Node

const CHIP1 = preload("res://assets/audio/sfx/Chips/201804__fartheststar__poker_chips4.wav")
const CHIP2 = preload("res://assets/audio/sfx/Chips/201805__fartheststar__poker_chips3.wav")
const CHIP3 = preload("res://assets/audio/sfx/Chips/201806__fartheststar__poker_chips2.wav")
const CHIP4 = preload("res://assets/audio/sfx/Chips/201807__fartheststar__poker_chips1.wav")
const CHIP5 = preload("res://assets/audio/sfx/Chips/201808__fartheststar__poker_chips6.wav")
const CHIP6 = preload("res://assets/audio/sfx/Chips/201809__fartheststar__poker_chips5.wav")

var chipList = [CHIP1,CHIP2,CHIP3,CHIP4,CHIP5,CHIP6]
var valueRange = 0.0

func _ready() -> void:
	
	label.position = Vector2(label.position.x,479-(self.value*4.6))	
	label.text = str((value/100)*int(poker_game_processing.chips))

func _process(_delta) -> void:
	max_value = poker_game_processing.chips
	valueRange = max_value-min_value	
	
func _on_value_changed(sliderValue: float) -> void:
	var percentageValue = ((sliderValue-min_value)/valueRange)*100
	label.position = Vector2(label.position.x,479-(percentageValue*4.6))
	label.text = str(sliderValue)
	sound_effect.stream = chipList[randi_range(0,5)]
	sound_effect.play()

func change_min_value(minValue):
	min_value = minValue
