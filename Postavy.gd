extends Node2D

const SOUPER = preload("res://sceny/souper.tscn")
const CESTA = preload("res://sceny/cesta.tscn")

var predmety: Dictionary = {
	'sejf': preload("res://sceny/sejf.tscn"),
	'dvere': preload("res://sceny/dvere.tscn"),
	'vychod': preload("res://sceny/vychod.tscn")
}

@export var Mapa: Node2D

@onready var Hrac:= get_tree().get_first_node_in_group("hrac")


func _ready() -> void:
	Hrac.predmet_polozen.connect(nasadit_predmet)
	nasadit_predmety('dvere', Mapa.ziskat_seznam_globalne(Mapa.ziskat_dvere()))
	nasadit_predmety('vychod', Mapa.ziskat_seznam_globalne(Mapa.ziskat_vychody()))
	nasadit_predmet('sejf', Mapa.ziskat_globalne(Mapa.ziskat_stred()))
	await Signaly.noc_zacala
	nasadit_soupere(3, Mapa.ziskat_seznam_globalne(Mapa.ziskat_vychody()))


func nasadit_soupere(pocet:int, souradnice:Array) -> void:
	while souradnice.size() > pocet:
		souradnice.pop_at(randi_range(0, souradnice.size() -1))
	for pozice:Vector2i in souradnice:
		pridat_prvek(SOUPER, pozice)
		pridat_prvek(CESTA)


func pridat_prvek(scena:PackedScene, pozice:=Vector2i.ZERO) -> void:
	var prvek := scena.instantiate()
	add_child(prvek)
	prvek.position = pozice


func nasadit_predmet(nazev:StringName, pozice:Vector2i) -> void:
	var predmet: PackedScene = predmety.get(nazev)
	if predmet:
		pridat_prvek(predmet, pozice)
	else:
		push_warning('Předmět není rozpoznám')


func nasadit_predmety(nazev:StringName, souradnice:Array) -> void:
	for pozice:Vector2i in souradnice:
		nasadit_predmet(nazev, pozice)
