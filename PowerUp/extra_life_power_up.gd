extends Powerup

@export var add_armor: int = 1

func applyPowerup(body: ShipPlayer):
	body.add_armor(add_armor)
	pass
