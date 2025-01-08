extends Area2D

@export var Inventar: Resource

func _prichod_hrace(_body: Node2D) -> void:
	Inventar.predmet_zvednut.connect(_zvednuti)


func _odchod_hrace(_body: Node2D) -> void:
	Inventar.predmet_zvednut.disconnect(_zvednuti)


func _zvednuti() -> void:
	Inventar.pridat_predmet(owner.id)
	owner.queue_free()
