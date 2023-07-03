extends Area2D

##fall zone essa parte conecta o fallzone com o ação
func _on_fallzone_body_entered(body):
	
	get_tree().reload_current_scene()
