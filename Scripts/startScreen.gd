extends Control


func _ready():
	$controls/startBtn.grab_focus()
	


func _on_startBtn_pressed():
	get_tree().change_scene("res://Levels/Level01.tscn")

func _on_controlsBtn_pressed():
	var controlScreen = load("res://Scenes/controlsScreen.tscn").instance()
	get_tree().current_scene.add_child(controlScreen)


func _on_quitBtn_pressed():
	get_tree().quit()
