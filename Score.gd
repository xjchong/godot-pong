class_name Score
extends Label


export var player_id: int
export var _score: int = 0


func _ready():
	_update_text()
	

func increment() -> void:
	_score = _score + 1
	_update_text()


func _update_text() -> void:
	text = String(_score)
