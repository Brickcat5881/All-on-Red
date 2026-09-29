extends Sprite2D
const CARDFLICK_1 = preload("res://assets/audio/sfx/cardflick1.mp3")
const CARDFLICK_2 = preload("res://assets/audio/sfx/cardflick2.mp3")
const CARDFLICK_3 = preload("res://assets/audio/sfx/cardflick3.mp3")
const CARDDOWN_1 = preload("res://assets/audio/sfx/carddown1.mp3")
const CARDDOWN_2 = preload("res://assets/audio/sfx/carddown2.mp3")
const CARDDOWN_3 = preload("res://assets/audio/sfx/carddown3.mp3")
const BACK = preload("res://assets/images/back.png")

@onready var card_sound: AudioStreamPlayer2D = $CardSound


var multiplier = 1.2
var flickFx = [CARDFLICK_1,CARDFLICK_2,CARDFLICK_3]
var downFx = [CARDDOWN_1,CARDDOWN_2,CARDDOWN_3]
var timerCount = 0
var initialPosition : Vector2 

func _ready() -> void:
	var parentNode = self.get_parent()
	print(parentNode.name)
	if parentNode.name == "Hand Cards":
		self.texture = BACK
	initialPosition = position
func _process(_delta: float) -> void:
	pass
		
func _on_area_2d_mouse_entered() -> void:
	scale = scale*multiplier
	card_sound.stream = flickFx[randi_range(0,2)]
	card_sound.play()

func _on_area_2d_mouse_exited() -> void:
	scale = scale/multiplier
	card_sound.stream = downFx[randi_range(0,2)]
	card_sound.play()

func start_move_animation():
	position.y -= 100
	
func reset_card_positions_GD():
	position = initialPosition
