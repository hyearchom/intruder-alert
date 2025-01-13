extends CharacterBody2D

const RYCHLOST_CHUZE: float = 25.0
const RYCHLOST_BEHU: float = 70.0
#const VELIKOST_OTACENI: float = 4
var rychlost: float = RYCHLOST_CHUZE

@export var Denik: Resource
@onready var oznaceni := ziskat_oznaceni()

@export var Strach: Resource

@onready var Navigace: Node2D = $Navigace
@onready var Zahlednuti: Area2D = $Zahlednuti
@onready var Animace: AnimationPlayer = $Animace
@onready var Tvar: Sprite2D = $Tvar
@onready var Zpozdeni: Timer = $Zpozdeni


func ziskat_oznaceni() -> int:
	var pocet_souperu: int = get_tree().get_nodes_in_group('souperi').size()
	return pocet_souperu -1


func _ready() -> void:
	Zahlednuti.hrac_spatren.connect(utok)
	Zahlednuti.hrac_utekl.connect(mimo_dosah)
	Denik.porazka.connect(umrti)
	
	aktivovat_pohyb(false)
	await get_tree().process_frame
	Navigace.novy_cil(get_tree().get_first_node_in_group('sejf').global_position)
	Navigace.konec_trasy.connect(aktivovat_pohyb.bind(false))
	aktivovat_pohyb(true)


func utok(cil:=Vector2i.ZERO) -> void:
	# začátek natáčení k hráči 
	match Denik.boj:
		Postava.Styl_boje.UTEK:
			rychlost = RYCHLOST_BEHU
		Postava.Styl_boje.NA_BLIZKO:
			#máchání zbraní
			if cil:
				Navigace.novy_cil(cil)
		Postava.Styl_boje.NA_DALKU:
			aktivovat_pohyb(false)
			# střelba projektilů


func mimo_dosah() -> void:
	Strach.upravit(-5)
	# konec natáčení k hráči
	match Denik.boj:
		Postava.Styl_boje.UTEK:
			rychlost = RYCHLOST_CHUZE
		Postava.Styl_boje.NA_BLIZKO:
			# konec máchání zbraní
			pass
		Postava.Styl_boje.NA_DALKU:
			aktivovat_pohyb(true, false)
			# konec střelby projektilů

func umrti() -> void:
	aktivovat_pohyb(false)
	material = null
	Animace.play("umrti")
	await Animace.animation_finished
	if get_tree().get_nodes_in_group('souperi').size() == 1:
		Signaly.vyhra.emit()
		print('vyhra')
	queue_free()


func aktivovat_pohyb(stav:=true, rozestup:=true) -> void:
	var interval: float = 1
	if stav and rozestup:
		Zpozdeni.start(1 +oznaceni *interval)
		await Zpozdeni.timeout
	set_physics_process(stav)
	Navigace.aktivovat(stav)


func _physics_process(_delta: float) -> void:
	velocity = global_position.direction_to(Navigace.bod_trasy) *rychlost
	move_and_slide()
