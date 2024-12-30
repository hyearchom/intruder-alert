extends VBoxContainer

var uroven: int

@onready var Pocet: Label = $Pocet

func _ready() -> void:
	zvysit_uroven(0)


func zvysit_uroven(mira:=int(1)) -> void:
	uroven += mira
	Pocet.text = 'Threat Level: {0}'.format([str(uroven)])
