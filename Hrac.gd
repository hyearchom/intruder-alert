extends CharacterBody2D

const RYCHLOST_CHUZE: float = 100.0
const VELIKOST_OTACENI: float = 4

func _physics_process(_delta: float) -> void:
	var smer_otaceni := Input.get_axis("doleva", "doprava")
	if smer_otaceni:
		rotation_degrees += smer_otaceni *VELIKOST_OTACENI
	var pohled := Vector2.RIGHT.rotated(rotation)
	
	var smer_pohybu = pohled *Input.get_axis("dozadu", "dopredu")
	if smer_pohybu:
		velocity = smer_pohybu *RYCHLOST_CHUZE
	else:
		velocity = -smer_pohybu *RYCHLOST_CHUZE

	move_and_slide()
