extends Area2D


signal hrac_spatren
signal hrac_utekl


func _zahlednuti_hrace(_body: Node2D) -> void:
	hrac_spatren.emit()


func _zmizeni_hrace(_body: Node2D) -> void:
	hrac_utekl.emit()
