extends CharacterBody2D

const RYCHLOST_CHUZE: float = 25.0
#const VELIKOST_OTACENI: float = 4

var poklad := false
@onready var oznaceni := ziskat_oznaceni()
@export var Denik: Resource

@export var Strach: Resource

@onready var Navigace: Node2D = $Navigace
@onready var Animace: AnimationPlayer = $Animace
@onready var Tvar: Sprite2D = $Tvar
@onready var Zpozdeni: Timer = $Zpozdeni


func ziskat_oznaceni() -> int:
	var pocet_souperu: int = get_tree().get_nodes_in_group('souperi').size()
	return pocet_souperu -1


func _ready() -> void:
	Denik.porazka.connect(umrti)
	
	aktivovat_pohyb(false)
	await get_tree().process_frame
	Navigace.novy_cil(get_tree().get_first_node_in_group('sejf').global_position)
	Navigace.cil_dosazen.connect(aktivovat_pohyb.bind(false))
	aktivovat_pohyb(true)


func aktivovat_pohyb(stav:=true) -> void:
	var interval: float = 1
	if stav:
		Zpozdeni.start(1 +oznaceni *interval)
		await Zpozdeni.timeout
	set_physics_process(stav)
	Navigace.aktivovat(stav)


func _physics_process(_delta: float) -> void:
	velocity = global_position.direction_to(Navigace.bod_trasy) *RYCHLOST_CHUZE
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
	Strach.upravit(-5)
