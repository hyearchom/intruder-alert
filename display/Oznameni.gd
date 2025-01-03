extends Label

@onready var Zmizeni: Timer = $Zmizeni

func _ready() -> void:
	Signaly.prohra.connect(vypsat.bind('LOST'))
	Signaly.vyhra.connect(vypsat.bind('WIN'))
	Signaly.noc_zacala.connect(vypsat.bind('NIGHT', false))

func vypsat(zprava: StringName, konec:=true) -> void:
	text = zprava
	show()
	if konec and get_tree():
		get_tree().paused = true
	else:
		Zmizeni.start()
		await Zmizeni.timeout
		hide()
