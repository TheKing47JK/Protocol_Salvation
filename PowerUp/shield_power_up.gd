extends Powerup

@export var shieldTime: float = 6

func applyPowerup(body: ShipPlayer):
	body.applyShield(shieldTime)
	pass
