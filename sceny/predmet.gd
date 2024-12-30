extends RigidBody2D

@export var nazev: StringName

@onready var Hrac := get_tree().get_first_node_in_group('hrac')
@onready var Citlivost: Area2D = $Citlivost


func _ready() -> void:
	
	add_to_group(nazev)
	#add_to_group('predmety')


func _prichod_hrace(_body: Node2D) -> void:
	Hrac.predmet_zvednut.connect(_zvednuti)


func _odchod_hrace(_body: Node2D) -> void:
	Hrac.predmet_zvednut.disconnect(_zvednuti)


func _zvednuti() -> void:
	Hrac.pridat_predmet(nazev)
	queue_free()
	
#
#func _enter_tree() -> void:
	#get_tree().call_group('souperi', 'novy_cil', self)
