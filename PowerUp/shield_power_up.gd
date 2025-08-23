extends Powerup

@export var shieldTime: float = 6

func applyPowerup(body: ShipPlayer):
	body.applyShield(shieldTime)
	var ui = get_tree().get_first_node_in_group("powerup_ui")
	if ui:
		ui.activate_powerup("Shield Boost", 6.0, Color(1.0, 0.0, 0.0))
	pass
