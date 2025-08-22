extends Powerup

@export var boostTime: float = 10

func applyPowerup(body: ShipPlayer):
	body.applySpeedBoost(boostTime)
	pass
