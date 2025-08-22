extends Powerup

@export var RapidTime: float = 10

func applyPowerup(body: ShipPlayer):
	body.applyRapidFire(RapidTime)
	pass
