@tool
extends Node

@export var nazev: String
@export var skript: Script
@export var nazev_seznamu: StringName

func _ready() -> void:
	print(vytvorit_zneni())


func vytvorit_zneni() -> String:
	var odkaz: String = 'preload("res://sceny/predmety/{0}.tscn")'.format([nazev])
	var zapsat: String = "\n'{0}': {1}".format([nazev, odkaz])
	return zapsat


#func vytvorit_radek() -> void:
	#if nazev_seznamu in skript:
		#skript.set(nazev_seznamu, skript.get(nazev_seznamu) + vytvorit_zneni())
	#else:
		#push_error(nazev_seznamu + ' nenalezen')
