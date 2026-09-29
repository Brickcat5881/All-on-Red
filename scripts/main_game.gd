extends Node2D
@onready var sound_fx: AudioStreamPlayer2D = $BackgroundStuff/soundFx
@onready var bet_slider: VSlider = $GUI/betSlider
@onready var player_pile: Sprite2D = $Sprites/playerPile
@onready var ai_pile: Sprite2D = $Sprites/AIPile
@onready var menu_button: Button = $GUI/MenuButton


@onready var card_1: Sprite2D = $"PokerGameProcessing/Table Cards/Card1"
@onready var card_2: Sprite2D = $"PokerGameProcessing/Table Cards/Card2"
@onready var card_3: Sprite2D = $"PokerGameProcessing/Table Cards/Card3"
@onready var card_4: Sprite2D = $"PokerGameProcessing/Table Cards/Card4"
@onready var card_5: Sprite2D = $"PokerGameProcessing/Table Cards/Card5"
@onready var poker_game_processing: Node = $PokerGameProcessing

const CARDFLICK_2 = preload("res://assets/audio/sfx/cardflick2.mp3")
const PLAYING_CARD_SPRITE_SHEET = preload("res://assets/images/playingCardSpriteSheet.jpg")

const AI_FULL = preload("res://assets/images/chipPiles/AIFull.png")
const AI_MEDIUM = preload("res://assets/images/chipPiles/AIMedium.png")
const AI_MINIMUM = preload("res://assets/images/chipPiles/AIMinimum.png")
const AI_SMALL = preload("res://assets/images/chipPiles/AISmall.png")
const AI_VERY_SMALL = preload("res://assets/images/chipPiles/AIVerySmall.png")
const PLAYER_FULL = preload("res://assets/images/chipPiles/playerFull.png")
const PLAYER_MEDIUM = preload("res://assets/images/chipPiles/playerMedium.png")
const PLAYER_MINIMUM = preload("res://assets/images/chipPiles/playerMinimum.png")
const PLAYER_SMALL = preload("res://assets/images/chipPiles/playerSmall.png")
const PLAYER_VERY_SMALL = preload("res://assets/images/chipPiles/playerVerySmall.png")

var cardWidth: int = 256 
var cardHeight: int = 356
func _ready() -> void:
	print(OS.get_data_dir())
	card_1.hide()
	card_2.hide()
	card_3.hide()
	card_4.hide()
	card_5.hide()
	MenuMusic.stop()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if poker_game_processing.playerPot > 200:
		player_pile.show()
		player_pile.texture = PLAYER_FULL
	elif poker_game_processing.playerPot > 150:
		player_pile.show()
		player_pile.texture = PLAYER_MEDIUM
	elif poker_game_processing.playerPot > 100:
		player_pile.show()
		player_pile.texture = PLAYER_SMALL
	elif poker_game_processing.playerPot > 50:
		player_pile.show()
		player_pile.texture = PLAYER_VERY_SMALL
	elif poker_game_processing.playerPot > 0:
		player_pile.show()
		player_pile.texture = PLAYER_MINIMUM
	else:
		player_pile.hide()
	
	if poker_game_processing.playerPot > 200:
		ai_pile.show()
		ai_pile.texture = AI_FULL
	elif poker_game_processing.playerPot > 150:
		ai_pile.show()
		ai_pile.texture = AI_MEDIUM
	elif poker_game_processing.playerPot > 100:
		ai_pile.show()
		ai_pile.texture = AI_SMALL
	elif poker_game_processing.playerPot > 50:
		ai_pile.show()
		ai_pile.texture =AI_VERY_SMALL
	elif poker_game_processing.playerPot > 0:
		ai_pile.show()
		ai_pile.texture = AI_MINIMUM
	else:
		ai_pile.hide()
		
func card_name_to_Rect2(card_name):
	var cardDictionary = {
		# Clubs (Row 0)
		"Ac": Rect2(0 * self.cardWidth, 0 * self.cardHeight, self.cardWidth, self.cardHeight),
		"2c": Rect2(1 * self.cardWidth, 0 * self.cardHeight, self.cardWidth, self.cardHeight),
		"3c": Rect2(2 * self.cardWidth, 0 * self.cardHeight, self.cardWidth, self.cardHeight),
		"4c": Rect2(3 * self.cardWidth, 0 * self.cardHeight, self.cardWidth, self.cardHeight),
		"5c": Rect2(4 * self.cardWidth, 0 * self.cardHeight, self.cardWidth, self.cardHeight),
		"6c": Rect2(5 * self.cardWidth, 0 * self.cardHeight, self.cardWidth, self.cardHeight),
		"7c": Rect2(6 * self.cardWidth, 0 * self.cardHeight, self.cardWidth, self.cardHeight),
		"8c": Rect2(7 * self.cardWidth, 0 * self.cardHeight, self.cardWidth, self.cardHeight),
		"9c": Rect2(8 * self.cardWidth, 0 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Tc": Rect2(9 * self.cardWidth, 0 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Jc": Rect2(10 * self.cardWidth, 0 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Qc": Rect2(11 * self.cardWidth, 0 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Kc": Rect2(12 * self.cardWidth, 0 * self.cardHeight, self.cardWidth, self.cardHeight),

		# Hearts (Row 1)
		"Ah": Rect2(0 * self.cardWidth, 1 * self.cardHeight, self.cardWidth, self.cardHeight),
		"2h": Rect2(1 * self.cardWidth, 1 * self.cardHeight, self.cardWidth, self.cardHeight),
		"3h": Rect2(2 * self.cardWidth, 1 * self.cardHeight, self.cardWidth, self.cardHeight),
		"4h": Rect2(3 * self.cardWidth, 1 * self.cardHeight, self.cardWidth, self.cardHeight),
		"5h": Rect2(4 * self.cardWidth, 1 * self.cardHeight, self.cardWidth, self.cardHeight),
		"6h": Rect2(5 * self.cardWidth, 1 * self.cardHeight, self.cardWidth, self.cardHeight),
		"7h": Rect2(6 * self.cardWidth, 1 * self.cardHeight, self.cardWidth, self.cardHeight),
		"8h": Rect2(7 * self.cardWidth, 1 * self.cardHeight, self.cardWidth, self.cardHeight),
		"9h": Rect2(8 * self.cardWidth, 1 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Th": Rect2(9 * self.cardWidth, 1 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Jh": Rect2(10 * self.cardWidth, 1 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Qh": Rect2(11 * self.cardWidth, 1 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Kh": Rect2(12 * self.cardWidth, 1 * self.cardHeight, self.cardWidth, self.cardHeight),

		# Spades (Row 2)
		"As": Rect2(0 * self.cardWidth, 2 * self.cardHeight, self.cardWidth, self.cardHeight),
		"2s": Rect2(1 * self.cardWidth, 2 * self.cardHeight, self.cardWidth, self.cardHeight),
		"3s": Rect2(2 * self.cardWidth, 2 * self.cardHeight, self.cardWidth, self.cardHeight),
		"4s": Rect2(3 * self.cardWidth, 2 * self.cardHeight, self.cardWidth, self.cardHeight),
		"5s": Rect2(4 * self.cardWidth, 2 * self.cardHeight, self.cardWidth, self.cardHeight),
		"6s": Rect2(5 * self.cardWidth, 2 * self.cardHeight, self.cardWidth, self.cardHeight),
		"7s": Rect2(6 * self.cardWidth, 2 * self.cardHeight, self.cardWidth, self.cardHeight),
		"8s": Rect2(7 * self.cardWidth, 2 * self.cardHeight, self.cardWidth, self.cardHeight),
		"9s": Rect2(8 * self.cardWidth, 2 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Ts": Rect2(9 * self.cardWidth, 2 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Js": Rect2(10 * self.cardWidth, 2 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Qs": Rect2(11 * self.cardWidth, 2 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Ks": Rect2(12 * self.cardWidth, 2 * self.cardHeight, self.cardWidth, self.cardHeight),

		# Diamonds (Row 3)
		"Ad": Rect2(0 * self.cardWidth, 3 * self.cardHeight, self.cardWidth, self.cardHeight),
		"2d": Rect2(1 * self.cardWidth, 3 * self.cardHeight, self.cardWidth, self.cardHeight),
		"3d": Rect2(2 * self.cardWidth, 3 * self.cardHeight, self.cardWidth, self.cardHeight),
		"4d": Rect2(3 * self.cardWidth, 3 * self.cardHeight, self.cardWidth, self.cardHeight),
		"5d": Rect2(4 * self.cardWidth, 3 * self.cardHeight, self.cardWidth, self.cardHeight),
		"6d": Rect2(5 * self.cardWidth, 3 * self.cardHeight, self.cardWidth, self.cardHeight),
		"7d": Rect2(6 * self.cardWidth, 3 * self.cardHeight, self.cardWidth, self.cardHeight),
		"8d": Rect2(7 * self.cardWidth, 3 * self.cardHeight, self.cardWidth, self.cardHeight),
		"9d": Rect2(8 * self.cardWidth, 3 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Td": Rect2(9 * self.cardWidth, 3 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Jd": Rect2(10 * self.cardWidth, 3 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Qd": Rect2(11 * self.cardWidth, 3 * self.cardHeight, self.cardWidth, self.cardHeight),
		"Kd": Rect2(12 * self.cardWidth, 3 * self.cardHeight, self.cardWidth, self.cardHeight)
	}
	return cardDictionary[card_name]

	
func set_card(sprite_position: Rect2,targetCard: Sprite2D):
	targetCard.region_rect = sprite_position
	

func updateRegion(cardToChange: Sprite2D, cardValue: String):
	sound_fx.stream = CARDFLICK_2
	sound_fx.play()
	cardToChange.texture = PLAYING_CARD_SPRITE_SHEET
	var convertedValue = self.card_name_to_Rect2(cardValue)
	self.set_card(convertedValue,cardToChange)

func change_min_value_parent(minValue):
	bet_slider.change_min_value(minValue)

func updateSlider():
	bet_slider._ready()
	bet_slider._on_value_changed(bet_slider.value)


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
