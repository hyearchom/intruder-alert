extends Resource

signal zivoty_zmeneny
signal porazka

var zivoty: int


func zmena_zivotu(mira:int=-1) -> void:
	zivoty += mira
	zivoty_zmeneny.emit()
	if zivoty <= 0:
		porazka.emit()
