extends Node

var faze: int

enum Doba {
	PRIPRAVA,
	HLEDANI,
	UTEK,
	BOJ,
	PAUZA,
	SDELENI
}

func _ready() -> void:
	Signaly.truhla_otevrena.connect(_nova_faze.bind(Doba.UTEK))
	Signaly.vyhra.connect(_nova_faze.bind(Doba.SDELENI))
	Signaly.prohra.connect(_nova_faze.bind(Doba.SDELENI))


func _nova_faze(typ:int) -> void:
	faze = typ
