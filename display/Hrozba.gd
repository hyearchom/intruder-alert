extends Label

var uroven: int

func _ready() -> void:
	zvysit_uroven(0)


func zvysit_uroven(mira:=int(1)) -> void:
	uroven += mira
	text = 'Threat Level: {0}'.format([str(uroven)])
