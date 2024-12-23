extends Node2D

@onready var Prostory: TileMapLayer = $Prostory


func _ready() -> void:
	vytvorit_mapu()


func vytvorit_mapu(rozmer_mapy:=Vector2i(5,5)) -> void:
	for x in range(rozmer_mapy.x):
		for y in range(rozmer_mapy.y):
			pridat_mistnost(Vector2i(x,y))
	nastavit_nahodne_vychody(3, ziskat_dvere_ven())
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
	for souradnice in [
		plocha_mapy.end.x -1,
		plocha_mapy.end.y -1,
		plocha_mapy.position.x,
		plocha_mapy.position.y
		]:
			if souradnice not in limity_mapy:
				limity_mapy.append(souradnice)
	
	var dvere = ziskat_dvere()
	var vychody = dvere.filter(
		func(pozice:Vector2i): return (pozice.x in limity_mapy or pozice.y in limity_mapy))
	return vychody


func ziskat_dvere() -> Array:
	var policko_dveri := Vector2i(2,0)
	return Prostory.get_used_cells_by_id(1, policko_dveri)


func nastavit_nahodne_vychody(pocet:int, seznam_dveri:Array[Vector2i]) -> void:
	var teren_vychodu: int = 2
	var teren_steny: int = 3
	
	Prostory.set_cells_terrain_connect(seznam_dveri, 0, teren_steny)
	
	while seznam_dveri.size() > pocet:
		seznam_dveri.erase(seznam_dveri.pick_random())
	
	Prostory.set_cells_terrain_connect(seznam_dveri, 0, teren_vychodu)


func zablokovat_nahodne_dvere(pocet:int) -> void:
	var dvere: Array[Vector2i] = ziskat_dvere()
	
	for _i in range(pocet):
		var pozice_nahodnych_dveri: Vector2i = dvere.pick_random()
		dvere.erase(pozice_nahodnych_dveri)
		
		Prostory.set_cell(pozice_nahodnych_dveri, 1, Vector2i(4,0))

#func pridat_vychody() -> void:
	#var mozne_pozice: Array
	#for x in range(5):
		#mozne_pozice.append(Vector2i(x *rozmer_vzoru.x +3, 0))
	#Prostory.set_cells_terrain_connect(mozne_pozice, 0, 2)

#func nahodne_dvere(pozice:Vector2i) -> void:
	#var mozne_pozice: Array = [Vector2i(5,2), Vector2i(2,5)]
	#var pocet_zablokovanych_dveri := randi_range(0, mozne_pozice.size()) 
	#
	#for _i in range(pocet_zablokovanych_dveri):
		#mozne_pozice.pop_back()
	#for lokalni_pozice in mozne_pozice:
		#pridat_dvere(pozice, lokalni_pozice)
#
#func pridat_dvere(pozice:Vector2i) -> void:
	#var mozne_pozice: Array = [pozice *rozmer_vzoru + Vector2i(7,4), pozice *rozmer_vzoru + Vector2i(4,7)]
	#Prostory.set_cells_terrain_connect(mozne_pozice, 0, 1)
