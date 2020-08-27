class_name WinScreen
extends CanvasLayer


onready var blur_out_animation: AnimationPlayer = $ColorRect/BlurOutAnimation
onready var winner_dialog: WindowDialog = $ColorRect/CenterContainer/WinnerDialog
onready var win_audio: AudioStreamPlayer = $WinAudio
onready var hover_audio: AudioStreamPlayer = $HoverAudio
onready var confirm_audio: AudioStreamPlayer = $ConfirmAudio


func show(player_id: int):
	winner_dialog.dialog_text = "Player %s wins!" % player_id
	winner_dialog.get_close_button().hide()
	blur_out_animation.play("BlurOutAnimation")
	win_audio.play()


func _on_AcceptDialog_confirmed():
	confirm_audio.play()
	

func _on_AnimationPlayer_animation_finished(anim_name):
	winner_dialog.show()


func _on_ConfirmAudio_finished():
	get_tree().paused = false
	get_tree().change_scene("res://MainMenu.tscn")
