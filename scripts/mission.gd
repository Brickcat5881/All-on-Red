extends Label
@onready var progress_bar_1: ProgressBar = $ProgressBar1
@onready var reward_button: Button = $RewardButton
@onready var reward_label: Label = $RewardLabel



func _process(_delta: float) -> void:
	match position.y:
		1008.0:
			text = MissionHandler.missionData["mission1"]["name"]
			progress_bar_1.value = MissionHandler.missionData["mission1"]["progress"]*100
			reward_label.text = str(int(MissionHandler.missionData["mission1"]["reward"]))
		1269.0:
			text = MissionHandler.missionData["mission2"]["name"]
			progress_bar_1.value = MissionHandler.missionData["mission2"]["progress"]*100
			reward_label.text = str(int(MissionHandler.missionData["mission2"]["reward"]))
		1537.0:
			text = MissionHandler.missionData["mission3"]["name"]
			progress_bar_1.value = MissionHandler.missionData["mission3"]["progress"]*100
			reward_label.text = str(int(MissionHandler.missionData["mission3"]["reward"]))


func _on_reward_button_mouse_entered() -> void:
	reward_button.scale *= 1.2


func _on_reward_button_mouse_exited() -> void:
	reward_button.scale /= 1.2


func _on_reward_button_pressed() -> void:
	match position.y:
		1008.0:
			if MissionHandler.missionData["mission1"]["progress"] >= 1:
				MissionHandler.rollNewMission("mission1")
				MissionHandler.save_file(MissionHandler.missionData)
				MissionHandler.missionData["mission1"]["reward"] = randi_range(1,11) *25
				if MissionHandler.missionData["mission1"]["type"] == "play":
					MissionHandler.handsPlayed = 0
				elif MissionHandler.missionData["mission1"]["type"] == "win" and MissionHandler.missionData["mission1"]["condition"] == "none":
					MissionHandler.handsWon = 0
				ChipHandler.add_chips(int(reward_label.text))
		1269.0:
			if MissionHandler.missionData["mission2"]["progress"] >= 1:
				MissionHandler.rollNewMission("mission2")
				MissionHandler.save_file(MissionHandler.missionData)
				MissionHandler.missionData["mission2"]["reward"] = randi_range(1,11) *25
				if MissionHandler.missionData["mission2"]["type"] == "play":
					MissionHandler.handsPlayed = 0
				elif MissionHandler.missionData["mission2"]["type"] == "win" and MissionHandler.missionData["mission2"]["condition"] == "none":
					MissionHandler.handsWon = 0
				ChipHandler.add_chips(int(reward_label.text))
		1537.0:
			if MissionHandler.missionData["mission3"]["progress"] >= 1:
				MissionHandler.rollNewMission("mission3")
				MissionHandler.save_file(MissionHandler.missionData)
				MissionHandler.missionData["mission3"]["reward"] = randi_range(1,11) *25
				if MissionHandler.missionData["mission3"]["type"] == "play":
					MissionHandler.handsPlayed = 0
				elif MissionHandler.missionData["mission3"]["type"] == "win" and MissionHandler.missionData["mission3"]["condition"] == "none":
					MissionHandler.handsWon = 0
				ChipHandler.add_chips(int(reward_label.text))
			
