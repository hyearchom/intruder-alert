extends Node2D

const SOUPER = preload("res://souper.tscn")
const CESTA = preload("res://cesta.tscn")

var predmety = {
	'sejf': preload("res://sejf.tscn"),
	'dvere': preload("res://dvere.tscn"),
}

@export var Mapa: Node2D

@onready var Hrac:= get_tree().get_first_node_in_group("hrac")


func _ready() -> void:
	Hrac.predmet_polozen.connect(nasadit_predmet)
	nasadit_dvere(Mapa.ziskat_seznam_globalne(Mapa.ziskat_dvere()))
	nasadit_predmet('sejf', Mapa.ziskat_globalne(Mapa.ziskat_stred()))
	await Hrac.noc_zacala
	nasadit_soupere(3, Mapa.ziskat_seznam_globalne(Mapa.ziskat_vychody()))


func nasadit_soupere(pocet:int, souradnice:Array) -> void:
	while souradnice.size() > pocet:
		souradnice.pop_at(randi_range(0, souradnice.size()))
	for pozice:Vector2i in souradnice:
		pridat_prvek(SOUPER, pozice)
		pridat_prvek(CESTA)


func pridat_prvek(scena:PackedScene, pozice:=Vector2i.ZERO) -> void:
	var prvek := scena.instantiate()
	add_child(prvek)
	prvek.position = pozice


func nasadit_predmet(nazev:StringName, pozice:Vector2i) -> void:
	var predmet = predmety.get(nazev)
	if predmet:
		pridat_prvek(predmet, pozice)
	else:
		push_warning('Předmět není rozpoznám')


func nasadit_dvere(souradnice:Array) -> void:
	for pozice:Vector2i in souradnice:
		nasadit_predmet('dvere', pozice)
