extends Area2D

@onready var Hrozba: Control = get_node("/root/Hra/%Hrozba")


func _pruchod_soupere(_body: Node2D) -> void:
	Hrozba.zvysit_uroven()
