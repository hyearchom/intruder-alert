extends Label

var uroven: int

func _ready() -> void:
	zmenit_uroven(0)


func zmenit_uroven(mira:=int(1)) -> void:
	uroven += mira
	uroven = max(0, uroven)
	text = 'Threat Level: {0}'.format([str(uroven)])
