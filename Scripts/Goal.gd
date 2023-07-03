extends Area2D

func _on_goal_body_entered(body: Node) -> void:
	if body.name == "Player":
		$victoryFx.play()
		$confetti.emitting = true
		Global.checkpoint_pos = 0
		load_next_level()  # Chama a função para carregar a próxima fase
	
		
func load_next_level() -> void:
	var next_level_path = "res://score/Control.tscn"  # Substitua pelo caminho correto para a próxima cena
	get_tree().change_scene(next_level_path)
