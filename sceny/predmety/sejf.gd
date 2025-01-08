extends Node2D

#@export var nazev: StringName
@onready var id: StringName = name.to_lower()


func _ready() -> void:
	add_to_group(id)


func _priblizeni_soupere(body: Node2D) -> void:
	body.poklad = true
	Signaly.truhla_otevrena.emit()
	queue_free()
