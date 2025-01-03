extends Area2D

@export var nazev: StringName

@onready var id: StringName = name.to_lower()
@onready var Hrac := get_tree().get_first_node_in_group('hrac')

@onready var Tvar: Polygon2D = $Tvar


func _ready() -> void:
	add_to_group(id)
	#add_to_group('predmety')



func _prichod_soupere(_body: Node2D) -> void:
	Tvar.color = Color('1eff00')
