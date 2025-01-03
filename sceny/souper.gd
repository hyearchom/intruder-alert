extends CharacterBody2D

const RYCHLOST_CHUZE: float = 25.0
#const VELIKOST_OTACENI: float = 4

var seznam_cilu: Array
var bod_trasy: Vector2i
var postup_na_trase: int
var trasa: Array

@onready var Hrac:= get_tree().get_first_node_in_group("hrac")
@onready var Hrozba: Control = get_node("/root/Hra/%Hrozba")

@onready var navigacni_pole := get_world_2d().get_navigation_map()
@onready var oznaceni :=  ziskat_oznaceni()

@onready var Animace: AnimationPlayer = $Animace
@onready var Tvar: Sprite2D = $Tvar


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
	push_warning('Nemůžu najít soupeře ve stejnojmenné skupině')
	return -1


func novy_cil(cil:Vector2i, zmenit_pohyb:=true) -> void:
	seznam_cilu.append(cil)
	#print(seznam_cilu)
	if zmenit_pohyb:
		vypocitat_trasu(cil)
		dalsi_bod_cesty()


func vypocitat_trasu(cil:Vector2i) -> void:
	trasa = ziskat_cestu(cil)
	vykreslit_cestu()

#func vybrat_cil() -> Vector2i:
	#for cil: Node2D in seznam_cilu:
		#if cil:
			#return cil.global_position
	#return Hrac.global_position

func vykreslit_cestu() -> void:
	var cesty := get_tree().get_nodes_in_group('cesty')
	cesty[oznaceni].points = trasa


func dalsi_bod_cesty() -> void:
	postup_na_trase += 1
	#print(postup_na_trase)
	if postup_na_trase > trasa.size() -1:
		postup_na_trase = 0
		seznam_cilu.pop_front()
		if seznam_cilu:
			vypocitat_trasu(seznam_cilu[0])
		else:
			aktivovat_pohyb(false)
		#dalsi_bod_cesty()
	bod_trasy = trasa[postup_na_trase]


func aktivovat_pohyb(stav:=true) -> void:
	set_physics_process(stav)


func priblizeni_k_cily(cil:Vector2i) -> bool:
	var tolerance_priblizeni := 7
	#print(global_position.distance_to(cil))
	return global_position.distance_to(cil) < tolerance_priblizeni
	

func _ready() -> void:
	aktivovat_pohyb(false)
	await get_tree().process_frame
	novy_cil(get_tree().get_first_node_in_group('sejf').global_position)
	aktivovat_pohyb(true)


func _physics_process(_delta: float) -> void:
	if priblizeni_k_cily(bod_trasy):
		dalsi_bod_cesty()
	velocity = global_position.direction_to(bod_trasy) *RYCHLOST_CHUZE
	move_and_slide()


func umrti() -> void:
	aktivovat_pohyb(false)
	material = null
	Animace.play("umrti")
	await Animace.animation_finished
	if get_tree().get_nodes_in_group('souperi').size() == 1:
		Signaly.vyhra.emit()
		print('vyhra')
	queue_free()


func _zasah_hrace(_body: Node2D) -> void:
	Hrozba.zmenit_uroven(-5)
