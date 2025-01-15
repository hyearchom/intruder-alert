extends CharacterBody2D

signal strela_vypustena

const RYCHLOST_CHUZE: float = 25.0
const RYCHLOST_BEHU: float = 70.0
#const VELIKOST_OTACENI: float = 4
const INTERVAL_ROZESTUPU: float = 1.5
var rychlost: float = RYCHLOST_CHUZE
var pozorovan: Node2D

@export var Postava: Resource
@onready var oznaceni := ziskat_oznaceni()

@export var Strach: Resource

@onready var Navigace: Node2D = $Navigace
@onready var Zahlednuti: Area2D = $Zahlednuti
@onready var Animace: AnimationPlayer = $Animace
@onready var Tvar: Sprite2D = $Tvar
@onready var Zpozdeni: Timer = $Zpozdeni

@onready var Zbran: Node2D = $Zbran
@onready var Mec: Polygon2D = $Zbran/Mec
@onready var Luk: Polygon2D = $Zbran/Luk

@onready var Seknuti: AnimationPlayer = Mec.get_node('Seknuti')
@onready var Vystrel: AnimationPlayer = Luk.get_node('Vystrel')
@onready var Napnuti: Timer = Luk.get_node('Napnuti')
@onready var Zalozeni: Marker2D = Luk.get_node('Zalozeni')


func ziskat_oznaceni() -> int:
	var pocet_souperu: int = get_tree().get_nodes_in_group('souperi').size()
	return pocet_souperu -1


func _ready() -> void:
	_zobrazit_zbran()
	Postava.prezbrojeni.connect(_zobrazit_zbran)
	Zahlednuti.hrac_spatren.connect(utok)
	Zahlednuti.hrac_utekl.connect(mimo_dosah)
	Postava.porazka.connect(umrti)
	
	aktivovat_pohyb(false)
	await get_tree().process_frame
	Navigace.novy_cil(get_tree().get_first_node_in_group('sejf').global_position)
	Navigace.konec_trasy.connect(aktivovat_pohyb.bind(false))
	aktivovat_pohyb(true)


func utok(pozice:Node2D, zamereni:=true) -> void:
	pozorovan = pozice
	
	match Postava.boj:
		Denik.Styl_boje.UTEK:
			rychlost = RYCHLOST_BEHU
		Denik.Styl_boje.NA_BLIZKO:
			if zamereni:
				Navigace.novy_cil(pozice)
			_sekani()
		Denik.Styl_boje.NA_DALKU:
			if zamereni:
				aktivovat_pohyb(false)
			_strelba()


func mimo_dosah() -> void:
	Strach.upravit(-5)
	pozorovan = null
	
	match Postava.boj:
		Denik.Styl_boje.UTEK:
			rychlost = RYCHLOST_CHUZE
		Denik.Styl_boje.NA_BLIZKO:
			_sekani(false)
		Denik.Styl_boje.NA_DALKU:
			aktivovat_pohyb(true, false)
			_strelba(false)


func umrti() -> void:
	aktivovat_pohyb(false)
	material = null
	Animace.play("umrti")
	await Animace.animation_finished
	if get_tree().get_nodes_in_group('souperi').size() == 1:
		Signaly.vyhra.emit()
	queue_free()


func aktivovat_pohyb(stav:=true, rozestup:=true) -> void:
	if stav and rozestup:
		Zpozdeni.start(1 +oznaceni *INTERVAL_ROZESTUPU)
		await Zpozdeni.timeout
	set_physics_process(stav)
	Navigace.aktivovat(stav)


func _physics_process(_delta: float) -> void:
	velocity = global_position.direction_to(Navigace.bod_trasy) *rychlost
	otoceni(Navigace.bod_trasy)
	move_and_slide()


func otoceni(pozice:Vector2i) -> void:
	if pozorovan:
		pozice = pozorovan.global_position
	rotation = global_position.angle_to_point(pozice)


func _zobrazit_zbran() -> void:
	for zbran in Zbran.get_children():
		zbran.hide()
	match Postava.boj:
		Denik.Styl_boje.NA_BLIZKO:
			Mec.show()
		Denik.Styl_boje.NA_DALKU:
			Luk.show()


func _sekani(stav:=true) -> void:
	if stav:
		Seknuti.play(Seknuti.get_animation_list()[-1])
	else:
		await get_tree().process_frame
		Seknuti.play("RESET")


func _hrac_seknut(body: Node2D) -> void:
	body.Postava.zmena_zivotu(-1)


func _strelba(stav:=true) -> void:
	if stav:
		strela_vypustena.emit(
			Zalozeni.global_position,
			global_position.direction_to(pozorovan.global_position)
			)
		Vystrel.play(Vystrel.get_animation_list()[-1])
		Napnuti.start()
	else:
		Napnuti.stop()
