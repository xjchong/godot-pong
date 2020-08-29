class_name WinScreen
extends CanvasLayer


onready var blur_out_animation: AnimationPlayer = $ColorRect/BlurOutAnimation
onready var winner_dialog: WindowDialog = $ColorRect/CenterContainer/WinnerDialog


func show(player_id: int):
	winner_dialog.dialog_text = "Player %s wins!" % player_id
	winner_dialog.get_close_button().hide()
	blur_out_animation.play("BlurOutAnimation")
	AudioManager.play(Audio.VICTORY)
	yield(blur_out_animation, "animation_finished")
	winner_dialog.show()


func _on_AcceptDialog_confirmed():
	AudioManager.play(Audio.PRESS)
	yield(confirm_audio, "finished")
	get_tree().paused = false
	get_tree().change_scene(GlobalPath.MAIN_MENU)
