extends VBoxContainer

@onready var Ruce: Label = %Ruce

func _ready() -> void:
	drzi()

func drzi(predmet:StringName='') -> void:
	if predmet:
		Ruce.text = 'In hands: {0}'.format([predmet.to_upper()])
	else:
		Ruce.text = 'Empty hands'
