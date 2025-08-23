extends Powerup

@export var add_armor: int = 1

func applyPowerup(body: ShipPlayer):
	body.add_armor(add_armor)
	var ui = get_tree().get_first_node_in_group("powerup_ui")
	if ui:
		ui.activate_powerup("Extra Life", 1.0, Color(0.0, 1.0, 0.0))
	pass
