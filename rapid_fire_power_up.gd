extends Powerup

@export var rapidFireTime: float = 6

func applyPowerup(body: ShipPlayer):
	body.applyRapidFire(rapidFireTime)
	pass
