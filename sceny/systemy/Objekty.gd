extends Node2D

const SOUPER = preload("res://sceny/souper.tscn")
const CESTA = preload("res://sceny/cesta.tscn")
const VYCHOD = preload("res://sceny/vychod.tscn")
const DVERE = preload("res://sceny/dvere.tscn")

var sceny_predmetu: Dictionary = {
	'sejf': preload("res://sceny/predmety/sejf.tscn"),
	'senzor': preload("res://sceny/predmety/senzor.tscn"),
	'bomba': preload("res://sceny/predmety/bomba.tscn"),
	'imp': preload("res://sceny/predmety/imp.tscn"),
	'lahev': preload("res://sceny/predmety/lahev.tscn")
}

@export var Inventar: Resource
@export var Mapa: Node2D

#@onready var Hrac:= get_tree().get_first_node_in_group("hrac")


func _ready() -> void:
	Inventar.predmet_polozen.connect(nasadit_predmet)
	for pozice: Vector2i in Mapa.ziskat_pole(Mapa.pole.dvere, true):
		pridat_prvek(DVERE, pozice)
	for pozice: Vector2i in Mapa.ziskat_pole(Mapa.pole.vychody, true):
		pridat_prvek(VYCHOD, pozice)
	nasadit_predmet('sejf', Mapa.ziskat_stred(true))
	await Signaly.noc_zacala
	nasadit_soupere(3, Mapa.ziskat_pole(Mapa.pole.vychody, true))


func nasadit_soupere(pocet:int, souradnice:Array) -> void:
	while souradnice.size() > pocet:
		souradnice.pop_at(randi_range(0, souradnice.size() -1))
	for _i in range(pocet):
		var pozice: Vector2i = souradnice.pick_random()
		pridat_prvek(SOUPER, pozice)
		pridat_prvek(CESTA)


func pridat_prvek(scena:PackedScene, pozice:=Vector2i.ZERO) -> void:
	var prvek := scena.instantiate()
	add_child(prvek)
	prvek.position = pozice


func nasadit_predmet(nazev:StringName, pozice:Vector2i) -> void:
	var predmet: PackedScene = sceny_predmetu.get(nazev)
	if predmet:
		pridat_prvek(predmet, pozice)
	else:
		push_warning('Předmět není rozpoznám')


#func nasadit_predmety(nazev:StringName, souradnice:Array) -> void:
	#for pozice:Vector2i in souradnice:
		#nasadit_predmet(nazev, pozice)
