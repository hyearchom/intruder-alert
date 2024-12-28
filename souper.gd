extends CharacterBody2D

const RYCHLOST_CHUZE: float = 50.0
#const VELIKOST_OTACENI: float = 4

var cil_trasy: Vector2i
var bod_trasy: int
var trasa: Array

@onready var navigacni_pole := get_world_2d().get_navigation_map()
@onready var oznaceni :=  ziskat_oznaceni()

func ziskat_cestu(cil:Vector2i) -> PackedVector2Array:
	var cesta := NavigationServer2D.map_get_path(
		navigacni_pole, 
		global_position, 
		cil,
		false
		)
	return cesta


func ziskat_oznaceni() -> int:
	var poradi := int(0)
	for souper in get_tree().get_nodes_in_group('souperi'):
		if souper == self:
			return poradi
		poradi += 1
	return -1

func vypocitat_trasu(cil:Vector2i) -> void:
	trasa = ziskat_cestu(cil)
	vykreslit_cestu()


func vykreslit_cestu() -> void:
	var cesty := get_tree().get_nodes_in_group('cesty')
	cesty[oznaceni].points = trasa


func dalsi_bod_cesty() -> void:
	bod_trasy += 1
	if bod_trasy > trasa.size() -1:
		bod_trasy = 0
		vypocitat_trasu(get_tree().get_first_node_in_group("hrac").position)
	cil_trasy = trasa[bod_trasy]
	

func priblizeni_k_cily(cil:Vector2i) -> bool:
	var tolerance_priblizeni := 7
	return global_position.distance_to(cil) < tolerance_priblizeni
	

func _ready() -> void:
	set_physics_process(false)
	await get_tree().process_frame
	vypocitat_trasu(get_tree().get_first_node_in_group("hrac").position)
	dalsi_bod_cesty()
	set_physics_process(true)


func _physics_process(_delta: float) -> void:
	if priblizeni_k_cily(cil_trasy):
		dalsi_bod_cesty()
	velocity = global_position.direction_to(cil_trasy) *RYCHLOST_CHUZE
	move_and_slide()
