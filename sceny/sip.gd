extends CharacterBody2D

const RYCHLOST_POHYBU := 150.0

var smer_pohybu: Vector2

func _ready() -> void:
	await get_tree().process_frame
	rotation = smer_pohybu.angle()
	#print(smer_pohybu)

func _physics_process(delta: float) -> void:
	var kolize := move_and_collide(smer_pohybu *RYCHLOST_POHYBU *delta)
	if kolize:
		var obet := kolize.get_collider()
		if obet.is_in_group('hrac'):
			obet.Postava.zmena_zivotu(-1)
		queue_free()
	
