extends Area2D

@onready var Hrac := get_tree().get_first_node_in_group('hrac')

func _prichod_hrace(_body: Node2D) -> void:
	Hrac.predmet_zvednut.connect(_zvednuti)


func _odchod_hrace(_body: Node2D) -> void:
	Hrac.predmet_zvednut.disconnect(_zvednuti)


func _zvednuti() -> void:
	Hrac.pridat_predmet(owner.id, owner.nazev)
	owner.queue_free()
