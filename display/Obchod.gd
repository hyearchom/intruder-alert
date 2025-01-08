extends VBoxContainer

@export var Strach: Resource
@export var Inventar: Resource

#@onready var Hrac:= get_tree().get_first_node_in_group("hrac")

const POLOZKA = preload("res://display/polozka.tscn")

#var nabidka: Array = [
	#{'id': 'senzor', 'nazev': 'sensor', 'cena': 1},
	#{'id': 'bomba', 'nazev': 'bomb', 'cena': 3}
#]


func _ready() -> void:
	for id: String in Inventar.databaze:
		var zaznam: Dictionary = Inventar.databaze[id]
		if zaznam.has('cena'):
			var tlacitko := POLOZKA.instantiate()
			tlacitko.text = zaznam.nazev.capitalize()
			tlacitko.id = id
			tlacitko.cena = zaznam.cena
			add_child(tlacitko)
			tlacitko.pressed.connect(nakup.bind(tlacitko))


func nakup(tlacitko: Button) -> void:
	if Strach.uroven >= tlacitko.cena:
		Inventar.pridat_predmet(tlacitko.id)
		Strach.upravit(-tlacitko.cena)
