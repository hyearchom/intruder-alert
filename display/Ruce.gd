extends VBoxContainer

@export var Inventar: Resource

@onready var Popis: Label = %Popis

func _ready() -> void:
	Inventar.predmet_vybran.connect(vypsat_predmet)
	vypsat_predmet('')

func vypsat_predmet(predmet:StringName='') -> void:
	if predmet:
		Popis.text = 'In hands: {0}'.format([predmet.to_upper()])
	else:
		Popis.text = 'Empty hands'
