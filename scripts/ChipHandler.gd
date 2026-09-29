extends Node

const CHIP_DATA_PATH = "user://ChipData.json"
const BASE_DATA = {
	"playerChips": 1000
}
var chipData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	chipData = load_data()
	save_file(chipData,false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
		

func save_file(data,isInt):
	if isInt:
		var file = FileAccess.open(CHIP_DATA_PATH, FileAccess.WRITE)
		file.store_string('{"playerChips": '+str(data)+'}')
		file.close()
	else:
		var file = FileAccess.open(CHIP_DATA_PATH, FileAccess.WRITE)
		file.store_string(str(data))
		file.close()

func load_data():
	var file = FileAccess.open(CHIP_DATA_PATH, FileAccess.READ)
	if !FileAccess.file_exists(CHIP_DATA_PATH):
		
		save_file(BASE_DATA,false)
		
	else:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		return data
	return BASE_DATA

func get_chips():
	return chipData["playerChips"]

func add_chips(value):
	chipData["playerChips"] += value
	save_file(chipData,false)
	
func set_chips(value):
	chipData["playerChips"] = value
	save_file(chipData,false)


	
