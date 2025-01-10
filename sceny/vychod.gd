extends Area2D

@onready var Hra: Node = $"/root/Hra"

func _pruchod_soupere(body: Node2D) -> void:
	if body.poklad:
		Signaly.emit_signal("prohra")
		queue_free()
	else:
		body.Navigace.novy_cil(global_position, false)
