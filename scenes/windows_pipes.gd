extends Area2D

signal hit
signal scored


func _on_body_entered(body: Node2D):
	hit.emit()


func _on_money_area_body_entered(body: Node2D):
	scored.emit()
