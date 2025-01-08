extends Resource

signal strach_upraven

var uroven: int

func upravit(mira:int=1) -> void:
	uroven += mira
	uroven = max(0, uroven)
	
	strach_upraven.emit(uroven)
