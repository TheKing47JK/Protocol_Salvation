extends Powerup

@export var RapidTime: float = 10

func applyPowerup(body: ShipPlayer):
	body.applyRapidFire(RapidTime)
	var ui = get_tree().get_first_node_in_group("powerup_ui")
	if ui:
		ui.activate_powerup("Rapid Fire", 10.0, Color(0.0, 0.4, 1.0))
	pass
