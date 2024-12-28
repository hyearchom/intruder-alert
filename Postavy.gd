extends Node2D

const SOUPER = preload("res://souper.tscn")
const CESTA = preload("res://cesta.tscn")

@export var Mapa: Node2D


func _ready() -> void:
	nasadit_soupere(Mapa.ziskat_seznam_globalne(Mapa.ziskat_vychody()), 3)


func nasadit_soupere(souradnice:Array, pocet:int) -> void:
	while souradnice.size() > pocet:
		souradnice.pop_at(randi_range(0, souradnice.size()))
	for pozice:Vector2i in souradnice:
		pridat_prvek(SOUPER, pozice)
		pridat_prvek(CESTA)


func pridat_prvek(scena:PackedScene, pozice:=Vector2i.ZERO) -> void:
	var prvek := scena.instantiate()
	add_child(prvek)
	prvek.position = pozice
