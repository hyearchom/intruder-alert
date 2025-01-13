extends CharacterBody2D


const RYCHLOST_CHUZE: float = 100.0
const VELIKOST_OTACENI: float = 4

@export var Inventar: Resource

@onready var Celo: Marker2D = $Celo


func _physics_process(_delta: float) -> void:
	ovladani_pohybu()
	move_and_slide()


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
		Inventar.predmet_zvednut.emit()
	elif event.is_action_released("polozit"):
		Inventar.predmet_polozen.emit(Inventar.odebrat_predmet(), Celo.global_position)
	elif event.is_action_released("zvolit"):
		Inventar.vybrat_dalsi_predmet()
	if event.is_action_released("noc"):
		Signaly.noc_zacala.emit()


func umrti() -> void:
	queue_free()
	Signaly.prohra.emit()
