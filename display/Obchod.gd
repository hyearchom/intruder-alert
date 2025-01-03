extends VBoxContainer

@onready var Hrozba: Control = get_node('../%Hrozba')
@onready var Hrac:= get_tree().get_first_node_in_group("hrac")

const POLOZKA = preload("res://display/polozka.tscn")

var nabidka: Array = [
	{'id': 'senzor', 'nazev': 'sensor', 'cena': 1},
	{'id': 'bomba', 'nazev': 'bomb', 'cena': 3}
]


func _ready() -> void:
	for polozka: Dictionary in nabidka:
		var tlacitko := POLOZKA.instantiate()
		tlacitko.text = polozka.nazev.capitalize()
		tlacitko.id = polozka.id
		tlacitko.cena = polozka.cena
		add_child(tlacitko)
		tlacitko.pressed.connect(nakup.bind(tlacitko))


func nakup(tlacitko: Button) -> void:
	if Hrozba.uroven >= tlacitko.cena:
		Hrac.pridat_predmet(tlacitko.id, tlacitko.text.to_lower())
		Hrozba.zmenit_uroven(-tlacitko.cena)
