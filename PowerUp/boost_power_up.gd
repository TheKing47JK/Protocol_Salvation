extends Powerup

@export var boostTime: float = 10

func applyPowerup(body: ShipPlayer):
	body.applySpeedBoost(boostTime)
	var ui = get_tree().get_first_node_in_group("powerup_ui")
	if ui:
		ui.activate_powerup("Speed Boost", 10.0, Color(1.0, 1.0, 0.0))
	pass
