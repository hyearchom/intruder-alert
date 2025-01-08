extends Label

@export var Strach: Resource

func _ready() -> void:
	Strach.strach_upraven.connect(vypsat_uroven)
	Strach.upravit(0)


func vypsat_uroven(mira:int) -> void:
	#uroven += mira
	#uroven = max(0, uroven)
	text = 'Level of Fear: {0}'.format([str(mira)])
