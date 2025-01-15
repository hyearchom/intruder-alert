extends Resource
class_name Souboj

signal zivoty_zmeneny
signal porazka

@export var zivoty: int


func zmena_zivotu(mira:int=-1) -> void:
	zivoty += mira
	zivoty_zmeneny.emit()
	print(zivoty)
	if zivoty <= 0:
		porazka.emit()
