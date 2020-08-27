class_name Goal
extends Area2D


signal goal_scored(player_id)

export var player_id: int

onready var goal_audio: AudioStreamPlayer = $GoalAudio


func _on_Area2D_body_entered(body):
	if body.is_in_group("ball"):
		emit_signal("goal_scored", player_id)
		goal_audio.play()
