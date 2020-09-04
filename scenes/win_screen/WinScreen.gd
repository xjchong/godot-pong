class_name WinScreen
extends CanvasLayer


onready var dim_rect: ColorRect = $DimRect
onready var dim_tween: Tween = $DimRect/DimTween
onready var blur_rect: ColorRect = $BlurRect
onready var blur_out_animation: AnimationPlayer = $BlurRect/BlurOutAnimation
onready var winner_dialog: WindowDialog = $BlurRect/CenterContainer/WinnerDialog


func show(player_id):
	blur_rect.visible = true
	
	if player_id == null:
		winner_dialog.dialog_text = "      Draw!"
	else:
		winner_dialog.dialog_text = "Player %s wins!" % player_id
		
	winner_dialog.get_close_button().hide()
	dim_tween.interpolate_property(
		dim_rect, "color", dim_rect.color, Color(0, 0, 0, 0.6), 0.2
	)
	dim_tween.start()
	blur_out_animation.play("BlurOutAnimation")
	AudioManager.play(Audio.VICTORY)
	yield(blur_out_animation, "animation_finished")
	winner_dialog.show()


func _on_AcceptDialog_confirmed():
	AudioManager.play(Audio.PRESS)
	get_tree().paused = false
	get_tree().change_scene(GlobalPath.MAIN_MENU)
