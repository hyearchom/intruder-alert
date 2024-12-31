extends Area2D

var prvni_vyuziti := true

func _pruchod_soupere(body: Node2D) -> void:
	if prvni_vyuziti:
		body.novy_cil(global_position, false)
		prvni_vyuziti = false
	else:
		Signaly.prohra.emit()
		#prinwt(false)
