extends Area2D

@onready var id: StringName = name.to_lower()
@onready var Hrac := get_tree().get_first_node_in_group('hrac')

@onready var Tvar: Polygon2D = $Tvar


func _ready() -> void:
	add_to_group(id)
	await get_tree().create_timer(0.1).timeout
	_blizka_detekce()


func _blizka_detekce() -> void:
	for telo in get_overlapping_bodies():
		_prilakat_soupere(telo)


func _prilakat_soupere(telo: Node2D) -> void:
	if telo.Postava.overit_znak(Denik.Znaky.ALKOHOL):
		telo.Navigace.novy_cil(global_position)


func _prichod_soupere(body: Node2D) -> void:
	_prilakat_soupere(body)
