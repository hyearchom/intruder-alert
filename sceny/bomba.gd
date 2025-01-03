extends Area2D

@export var nazev: StringName

@onready var id: StringName = name.to_lower()
@onready var Hrac := get_tree().get_first_node_in_group('hrac')
@onready var Efekt: Polygon2D = $Dosah/Efekt

var dosah: Array

func _ready() -> void:
	add_to_group(id)
	#add_to_group('predmety')


func _protivnik_v_dosahu(body: Node2D) -> void:
	dosah.append(body)


func _protivnik_mimo_dosah(body: Node2D) -> void:
	dosah.erase(body)


func vybuch() -> void:
	for obet: Node2D in dosah:
		obet.queue_free()
	Efekt.show()
	await get_tree().create_timer(0.3).timeout
	queue_free()
