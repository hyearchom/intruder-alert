extends CharacterBody2D

signal predmet_zvednut
signal predmet_polozen

const RYCHLOST_CHUZE: float = 100.0
const VELIKOST_OTACENI: float = 4

var inventar: Array
var aktivni_predmet: int

@onready var Celo: Marker2D = $Celo
@onready var Predmet: Control = get_node("/root/Hra/%Predmet")


func _physics_process(_delta: float) -> void:
	ovladani_pohybu()
	move_and_slide()


func _exit_tree() -> void:
	Signaly.prohra.emit()


func ovladani_pohybu() -> void:
	var smer_otaceni := Input.get_axis("doleva", "doprava")
	if smer_otaceni:
		rotation_degrees += smer_otaceni *VELIKOST_OTACENI
	var pohled := Vector2.RIGHT.rotated(rotation)
	
	var smer_pohybu: Vector2 = pohled *Input.get_axis("dozadu", "dopredu")
	if smer_pohybu:
		velocity = smer_pohybu *RYCHLOST_CHUZE
	else:
		velocity = -smer_pohybu *RYCHLOST_CHUZE


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("zvednout"):
		predmet_zvednut.emit()
	elif event.is_action_released("polozit"):
		predmet_polozen.emit(odebrat_predmet(), Celo.global_position)
	elif event.is_action_released("zvolit"):
		vybrat_dalsi_predmet()
	if event.is_action_released("noc"):
		Signaly.noc_zacala.emit()


func odebrat_predmet() -> String:
	if not inventar:
		push_warning('Inventář je prázdný')
		return ''

	var predmet: Dictionary = inventar[aktivni_predmet]
	predmet.mnozstvi -= 1
	if predmet.mnozstvi == 0:
		inventar.erase(predmet)
		vybrat_dalsi_predmet()
	return predmet.id


func pridat_predmet(znacka:StringName, pojmenovani:StringName, pocet:=int(1)) -> void:
	inventar.append({'id': znacka, 'nazev': pojmenovani, 'mnozstvi': pocet})
	if inventar.size() == 1:
		vybrat_dalsi_predmet()


func vybrat_dalsi_predmet() -> void:
	var poradi: int = 0
	if inventar.size() > aktivni_predmet +1:
		poradi = aktivni_predmet +1
	if inventar:
		aktivni_predmet = poradi
		Predmet.drzi(inventar[poradi].nazev)
	else:
		Predmet.drzi()
