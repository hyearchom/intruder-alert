extends Resource

signal predmet_zvednut
signal predmet_polozen
signal predmet_vybran

var drzeny_predmet: int
var ulozene_predmety: Array

var databaze: Dictionary = {
	'sejf': {'nazev': 'chest'},
	'senzor': {'nazev': 'sensor', 'cena': 1},
	'imp': {'nazev': 'imp', 'cena': 2},
	'bomba': {'nazev': 'bomb', 'cena': 3},
	'lahev': {'nazev': 'bottle', 'cena': 5},
}


func odebrat_predmet() -> String:
	if not ulozene_predmety:
		push_warning('Inventář je prázdný')
		return ''

	var predmet: Dictionary = ulozene_predmety[drzeny_predmet]
	predmet.mnozstvi -= 1
	if predmet.mnozstvi == 0:
		ulozene_predmety.erase(predmet)
		vybrat_dalsi_predmet()
	return predmet.id


func pridat_predmet(znacka:StringName,pocet:=int(1)) -> void:
	ulozene_predmety.append(
		{'id': znacka, 'nazev': databaze[znacka].nazev, 'mnozstvi': pocet}
		)
	if ulozene_predmety.size() == 1:
		vybrat_dalsi_predmet()


func vybrat_dalsi_predmet() -> void:
	var poradi: int = 0
	if ulozene_predmety.size() > drzeny_predmet +1:
		poradi = drzeny_predmet +1
	if ulozene_predmety:
		drzeny_predmet = poradi
		predmet_vybran.emit(ulozene_predmety[poradi].nazev)
	else:
		predmet_vybran.emit('')
