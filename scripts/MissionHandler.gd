extends Node

const MISSION_DATA_PATH = "user://MissionData.json"
var missionList = {
	"Play 10 hands": {
		"amount": 10,
		"type": "play",
		"condition": "none"
	},
	"Play 12 hands": {
		"amount": 12,
		"type": "play",
		"condition": "none"
	},
	"Play 15 hands": {
		"amount": 15,
		"type": "play",
		"condition": "none"
	},
	"Play 20 hands": {
		"amount": 20,
		"type": "play",
		"condition": "none"
	},
	"Play 25 hands": {
		"amount": 25,
		"type": "play",
		"condition": "none"
	},
	"Win 3 hands": {
		"amount": 3,
		"type": "win",
		"condition": "none"
	},
	"Win 4 hands": {
		"amount": 4,
		"type": "win",
		"condition": "none"
	},
	"Win 5 hands": {
		"amount": 5,
		"type": "win",
		"condition": "none"
	},
	"Win 6 hands": {
		"amount": 6,
		"type": "win",
		"condition": "none"
	},
	"Win 7 hands": {
		"amount": 7,
		"type": "win",
		"condition": "none"
	},
	"Win 8 hands": {
		"amount": 8,
		"type": "win",
		"condition": "none"
	},
	"Win 9 hands": {
		"amount": 9,
		"type": "win",
		"condition": "none"
	},
	"Win 10 hands": {
		"amount": 10,
		"type": "win",
		"condition": "none"
	},
	"Win 2 hands in a row": {
		"amount": 2,
		"type": "win",
		"condition": "consecutive"
	},
	"Win 3 hands in a row": {
		"amount": 3,
		"type": "win",
		"condition": "consecutive"
	},
	"Win a hand with a high card": {
		"amount": 1,
		"type": "win",
		"condition": "High Card"
	},
	"Win a hand with a Pair": {
		"amount": 1,
		"type": "win",
		"condition": "Pair"
	},
	"Win a hand with a Two Pair": {
		"amount": 1,
		"type": "win",
		"condition": "Two Pair"
	},
	"Win a hand with a Three of a Kind": {
		"amount": 1,
		"type": "win",
		"condition": "Three of a Kind"
	},
	"Win a hand with a Straight": {
		"amount": 1,
		"type": "win",
		"condition": "Straight"
	},
	"Win a hand with a Flush": {
		"amount": 1,
		"type": "win",
		"condition": "Flush"
	},
	"Win a hand with a Full House": {
		"amount": 1,
		"type": "win",
		"condition": "Full House"
	},
	"Win a hand with a Four of a Kind": {
		"amount": 1,
		"type": "win",
		"condition": "Four of a Kind"
	},
	"Get a Pair": {
		"amount": 1,
		"type": "hand",
		"condition": "Pair"
	},
	"Get a Two Pair": {
		"amount": 1,
		"type": "hand",
		"condition": "Two Pair"
	},
	"Get a Three of a Kind": {
		"amount": 1,
		"type": "hand",
		"condition": "Three of a Kind"
	},
	"Get a Straight": {
		"amount": 1,
		"type": "hand",
		"condition": "Straight"
	},
	"Get a Flush": {
		"amount": 1,
		"type": "hand",
		"condition": "Flush"
	},
	"Get a Full House": {
		"amount": 1,
		"type": "hand",
		"condition": "Full House"
	},
	"Get a Four of a Kind": {
		"amount": 1,
		"type": "hand",
		"condition": "Four of a Kind"
	}
}
var missionData
var baseData = {
	"mission1": {
		"name": "",
		"progress": 0,
		"type": "",
		"condition": "",
		"amount": 0,
		"reward": 0
	},
	"mission2": {
		"name": "",
		"progress": 0,
		"type": "",
		"condition": "",
		"amount": 0,
		"reward": 0
	},
	"mission3": {
		"name": "",
		"progress": 0,
		"type": "",
		"condition": "",
		"amount": 0,
		"reward": 0
	},
	"progressData": {
		"handsWon": 0,
		"handsPlayed": 0
	}
}

var handsWon = 0
var handsPlayed = 0
var consecutiveWon = 0
var handClass = ""



func _ready() -> void:
	missionData = load_data()
	for i in range(1,4):
		if missionData["mission"+str(i)]["name"] == "":
			rollNewMission("mission"+str(i))
			missionData["mission"+str(i)]["reward"] = randi_range(1,11)*25
	handsWon = missionData["progressData"]["handsWon"]
	handsPlayed = missionData["progressData"]["handsPlayed"]
	save_file(missionData)

	
func _process(_delta: float) -> void:
	for i in range(1,4):
		if missionData["mission"+str(i)]["type"] == "play":
			missionData["mission"+str(i)]["progress"] = handsPlayed/missionData["mission"+str(i)]["amount"]
		elif missionData["mission"+str(i)]["condition"] == "consecutive":
			print(consecutiveWon/missionData["mission"+str(i)]["amount"])
			missionData["mission"+str(i)]["progress"] = consecutiveWon/missionData["mission"+str(i)]["amount"]
		elif missionData["mission"+str(i)]["type"] == "win":
			missionData["mission"+str(i)]["progress"] = handsWon/missionData["mission"+str(i)]["amount"]
	
func save_file(data):
	var file = FileAccess.open(MISSION_DATA_PATH, FileAccess.WRITE)
	file.store_string(str(data))
	file.close()

func load_data():
	var file = FileAccess.open(MISSION_DATA_PATH, FileAccess.READ)
	if !FileAccess.file_exists(MISSION_DATA_PATH):
		save_file(baseData)
	elif file.get_as_text() == "":
		file.close()
		save_file(baseData)
	else:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		return data
	return baseData

func addValue(attribute,value):
	match attribute:
		"handsWon": 
			handsWon += value
		"consequetiveWon":
			consecutiveWon += value
		"handsPlayed":
			handsPlayed += value
	
	save_file(missionData)
	
func setValue(attribute,value):
	match attribute:
		"handsWon": 
			handsWon = value
		"consequetiveWon":
			consecutiveWon = value
	save_file(missionData)
	
func wonWith(combo):
	for i in range(1,4): 
		if missionData["mission"+str(i)]["type"] == "win":
			matchCombo(combo,missionData["mission"+str(i)]["condition"],missionList[missionData["mission"+str(i)]["name"]]["amount"],i)
	save_file(missionData)
	
func hadCards(combo):
	for i in range(1,4): 
		if missionData["mission"+str(i)]["type"] == "hand":
			matchCombo(combo,missionData["mission"+str(i)]["condition"],missionData["mission"+str(i)]["amount"],i)
	save_file(missionData)
	
func matchCombo(combo,comboNeeded,progressNeeded,i):
	match comboNeeded:
		"High Card":
			if combo == "High Card": 
				missionData["mission"+str(i)]["progress"] += 1/progressNeeded
		"Pair":
			if combo == "Pair":
				missionData["mission"+str(i)]["progress"] += 1/progressNeeded
		"Two Pair":
			if combo == "Two Pair":
				missionData["mission"+str(i)]["progress"] += 1/progressNeeded
		"Three of a Kind":
			if combo == "Three of a Kind":
				missionData["mission"+str(i)]["progress"] += 1/progressNeeded
		"Straight":
			if combo == "Straight":
				missionData["mission"+str(i)]["progress"] += 1/progressNeeded
		"Flush":
			if combo == "Flush":
				missionData["mission"+str(i)]["progress"] += 1/progressNeeded
		"Full House":
			if combo == "Full House":
				missionData["mission"+str(i)]["progress"] += 1/progressNeeded
		"Four of a Kind":
			if combo == "Four of a Kind":
				missionData["mission"+str(i)]["progress"] += 1/progressNeeded


func rollNewMission(missionKey):
	var randomKey = missionList.keys().pick_random()
	missionData[missionKey]["name"] = randomKey
	missionData[missionKey]["progress"] = 0.0
	missionData[missionKey]["condition"] = missionList[randomKey]["condition"]
	missionData[missionKey]["amount"] = missionList[randomKey]["amount"]
	missionData[missionKey]["type"] = missionList[randomKey]["type"]
