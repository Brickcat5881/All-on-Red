extends AudioStreamPlayer2D

const MUSIC1 = preload("res://assets/audio/music/happy-jazz-music-casino-poker-black-jack-roulette-background-intro-269848.mp3")
const MUSIC2 = preload("res://assets/audio/music/jazz-background-music-bar-restaurant-casino-mafia-whiskey-249670.mp3")
const MUSIC3 = preload("res://assets/audio/music/jazz-music-casino-poker-roulette-las-vegas-background-intro-theme-287498.mp3")
const MUSIC4 = preload("res://assets/audio/music/jazz-music-whiskey-bar-restaurant-casino-background-intro-theme-263181.mp3")
const MUSIC5 = preload("res://assets/audio/music/casino-funky-background-upbeat-and-uplifting-music-intro-theme-120445.mp3")
const MUSIC6 = preload("res://assets/audio/music/casino-jazz-317385.mp3")
const MUSIC7 = preload("res://assets/audio/music/funk-upbeat-lottery-casino-pause-intro-background-intro-music-120443.mp3")
const MUSIC8 = preload("res://assets/audio/music/former-102685.mp3")
var musicArray = [MUSIC1,MUSIC2,MUSIC3,MUSIC4,MUSIC5,MUSIC6,MUSIC7,MUSIC8]
var index = 0

func _ready() -> void:
	index = randi_range(0,6)
	self.stream = musicArray[index]
	self.play()
func _on_finished() -> void:
	self.stream = musicArray[index]
	self.play()
	index += 1
	if index == 6:
		index = 0
