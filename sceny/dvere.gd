extends Area2D

@onready var Hrozba := get_tree().get_first_node_in_group("hrozba")

func _pruchod_soupere(_body: Node2D) -> void:
	Hrozba.zvysit_uroven()
