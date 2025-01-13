extends Resource
class_name Postava


signal zivoty_zmeneny
signal porazka

enum Znaky {
	ALKOHOL = -1,
	ZLATO = -2,
	KNIHY = -3,
	ZAMEK = 1,
}
var popis: Dictionary = {
	-1: 'Drinking problem',
	-2: 'Greed',
	-3: 'Obsessive curiosity',
	1: 'Lockpicking'
}
@export var vlastnosti: Array[Znaky]

enum Styl_boje {UTEK, NA_BLIZKO, NA_DALKU}
@export var boj: Styl_boje

var zivoty: int
var poklad := false


func nahodne_neresti(pocet:int) -> void:
	for _i in range(pocet):
		vlastnosti.append(randi_range(1, min(Znaky.values())) *-1)


func nahodne_schopnosti(pocet:int) -> void:
	for _i in range(pocet):
		vlastnosti.append(randi_range(1, max(Znaky.values())))


func overit_znak(poradi:int) -> bool:
	return poradi in vlastnosti


func zmena_zivotu(mira:int=-1) -> void:
	zivoty += mira
	zivoty_zmeneny.emit()
	if zivoty <= 0:
		porazka.emit()
