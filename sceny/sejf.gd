extends Node2D

@export var nazev: StringName
@onready var id: StringName = name.to_lower()


func _ready() -> void:
	add_to_group(id)
	#add_to_group('predmety')
