extends Node2D

@onready var Prostory: TileMapLayer = $Prostory

var pole: Dictionary = {
	'dvere': Vector2i(2,0),
	'vychody': Vector2i(3,0)
}


func _ready() -> void:
	_vytvorit_mapu()


func _vytvorit_mapu(rozmer_mapy:=Vector2i(5,5)) -> void:
	for x in range(rozmer_mapy.x):
		for y in range(rozmer_mapy.y):
			pridat_mistnost(Vector2i(x,y))
	nastavit_nahodne_vychody(1, ziskat_dvere_ven())
	zablokovat_nahodne_dvere(12)


func pridat_mistnost(pozice:Vector2i) -> void:
	var rozmer_vzoru := Vector2i.ONE *6
	Prostory.set_pattern(
		Vector2i(pozice.x *rozmer_vzoru.x, pozice.y *rozmer_vzoru.y),
		Prostory.tile_set.get_pattern(0)
		)


func ziskat_dvere_ven() -> Array:
	var limity_mapy: Array[int]
	var plocha_mapy := Prostory.get_used_rect()
	for souradnice:int in [
		plocha_mapy.end.x -1,
		plocha_mapy.end.y -1,
		plocha_mapy.position.x,
		plocha_mapy.position.y
		]:
			if souradnice not in limity_mapy:
				limity_mapy.append(souradnice)
	
	var dvere: Array = ziskat_pole(pole.dvere)
	var vychody: Array = dvere.filter(
		func(pozice:Vector2i)->bool: return (pozice.x in limity_mapy or pozice.y in limity_mapy))
	return vychody


func ziskat_pole(oznaceni_pole:Vector2i, globalne:=false) -> Array:
	#var policko_dveri := Vector2i(2,0)
	var seznam: Array = Prostory.get_used_cells_by_id(1, oznaceni_pole)
	if not globalne:
		return seznam
	else:
		return ziskat_seznam_globalne(seznam)


func nastavit_nahodne_vychody(pocet:int, seznam_dveri:Array[Vector2i]) -> void:
	var teren_vychodu: int = 2
	var teren_steny: int = 3
	
	Prostory.set_cells_terrain_connect(seznam_dveri, 0, teren_steny)
	
	while seznam_dveri.size() > pocet:
		seznam_dveri.erase(seznam_dveri.pick_random())
	
	Prostory.set_cells_terrain_connect(seznam_dveri, 0, teren_vychodu)


func zablokovat_nahodne_dvere(pocet:int) -> void:
	var dvere: Array[Vector2i] = ziskat_pole(pole.dvere)
	
	for _i in range(pocet):
		var pozice_nahodnych_dveri: Vector2i = dvere.pick_random()
		dvere.erase(pozice_nahodnych_dveri)
		
		Prostory.set_cell(pozice_nahodnych_dveri, 1, Vector2i(4,0))


#func ziskat_vychody(globalne:=false) -> Array:
	#var policko_vychodu := Vector2i(3,0)
	#var seznam: Array = Prostory.get_used_cells_by_id(1, policko_vychodu)
	#if not globalne:
		#return seznam
	#else:
		#return ziskat_seznam_globalne(seznam)


func ziskat_globalne(pozice:Vector2i) -> Vector2i:
	return Prostory.map_to_local(pozice)


func ziskat_seznam_globalne(souradnice:PackedVector2Array) -> PackedVector2Array:
	var seznam := Array(souradnice)
	return seznam.map(ziskat_globalne)


func ziskat_stred(globalne:=false) -> Vector2i:
	var stred: Vector2i = Prostory.get_used_rect().get_center()
	if not globalne:
		return stred
	else:
		return ziskat_globalne(stred)
