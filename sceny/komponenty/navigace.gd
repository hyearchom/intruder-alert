extends Node2D

signal konec_trasy

var seznam_cilu: Array
var bod_trasy: Vector2i
var postup_na_trase: int
var trasa: Array

@onready var navigacni_pole := get_world_2d().get_navigation_map()


func aktivovat(stav:=true) -> void:
	set_physics_process(stav)


func novy_cil(cil:Vector2i, zmenit_pohyb:=true) -> void:
	if zmenit_pohyb:
		seznam_cilu.push_front(cil)
		_vypocitat_trasu(cil)
		_dalsi_bod_cesty()
	else:
		if seznam_cilu.size() > 0:
			seznam_cilu.insert(1, cil)
		else:
			seznam_cilu.append(cil)


func _vypocitat_trasu(cil:Vector2i) -> void:
	trasa = _ziskat_cestu(cil)
	vykreslit_cestu()


func _ziskat_cestu(cil:Vector2i) -> PackedVector2Array:
	var cesta := NavigationServer2D.map_get_path(
		navigacni_pole, 
		global_position, 
		cil,
		false
		)
	return cesta


func _dalsi_bod_cesty() -> void:
	postup_na_trase += 1
	if postup_na_trase > trasa.size() -1:
		postup_na_trase = 0
		seznam_cilu.pop_front()
		if seznam_cilu:
			_vypocitat_trasu(seznam_cilu[0])
		else:
			konec_trasy.emit()
	bod_trasy = trasa[postup_na_trase]


func _physics_process(_delta: float) -> void:
	if _priblizeni_k_cily(bod_trasy):
		_dalsi_bod_cesty()


func _priblizeni_k_cily(cil:Vector2i) -> bool:
	var tolerance_priblizeni := 7
	return global_position.distance_to(cil) < tolerance_priblizeni


func vykreslit_cestu() -> void:
	var cesty := get_tree().get_nodes_in_group('cesty')
	if cesty:
		cesty[owner.oznaceni].points = trasa
	else:
		push_warning('Křivky pro znázornění trasy nenalezeny')
