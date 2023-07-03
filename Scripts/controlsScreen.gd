extends Control


func _ready():
	$return.grab_focus()


func _on_return_pressed():
	queue_free()
