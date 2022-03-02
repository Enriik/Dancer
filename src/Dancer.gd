extends Node2D

signal dancer_joined

# warning-ignore:unused_argument
func _on_Dancer_area_entered(area):
	if area.name == "Player":
		emit_signal("dancer_joined")
	queue_free()

