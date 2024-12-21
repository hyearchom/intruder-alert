extends Node2D

var rozmer_vzoru:= Vector2i.ONE *6

@onready var Prostory: TileMapLayer = $Prostory

func _ready() -> void:
	vytvorit_mapu()


func vytvorit_mapu(rozmer_mapy:=Vector2i(5,5)) -> void:
	for x in range(rozmer_mapy.x):
		for y in range(rozmer_mapy.y):
			pridat_mistnost(Vector2i(x,y))
			#nahodne_dvere(Vector2i(x,y))


func pridat_mistnost(pozice:Vector2i) -> void:
	Prostory.set_pattern(
		Vector2i(pozice.x *rozmer_vzoru.x, pozice.y *rozmer_vzoru.y),
		Prostory.tile_set.get_pattern(0)
		)

#func nahodne_dvere(pozice:Vector2i) -> void:
	#var mozne_pozice: Array = [Vector2i(5,2), Vector2i(2,5)]
	#var pocet_zablokovanych_dveri := randi_range(0, mozne_pozice.size()) 
	#
	#for _i in range(pocet_zablokovanych_dveri):
		#mozne_pozice.pop_back()
	#for lokalni_pozice in mozne_pozice:
		#pridat_dvere(pozice, lokalni_pozice)
#
#func pridat_dvere(pozice:Vector2i, lokalni_pozice:Vector2i) -> void:
	#Prostory.set_cell(
		#Vector2i(
			#pozice.x *rozmer_vzoru.x +lokalni_pozice.x,
			#pozice.y *rozmer_vzoru.y +lokalni_pozice.y),
		#2,
		#Vector2i(2,0)
	#)
