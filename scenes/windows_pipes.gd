extends Area2D

signal hit
signal scored
var already_scored = false


func _on_body_entered(body: Node2D):
	hit.emit()

func _on_money_area_body_entered(body: Node2D):
	if  not already_scored:
		already_scored = true 
		scored.emit()
		$money_area.monitoring = false 
		$money_area/CollisionShape2D.disabled = true 
		$money_area/Sprite2D.hide()
