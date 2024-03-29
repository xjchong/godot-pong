class_name Goal
extends Area2D


signal goal_scored(player_id)

export var player_id: int


func _on_Area2D_body_entered(body):
	if body.is_in_group("ball"):
		emit_signal("goal_scored", player_id)
		AudioManager.play(Audio.GOAL)
