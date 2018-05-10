extends Node2D

const SCALE_RADIUS_DIVIDER = 200;

export (float) var radius;
export (float) var gravity;


func _ready():
	scale.x = radius / SCALE_RADIUS_DIVIDER;
	scale.y = radius / SCALE_RADIUS_DIVIDER;
#	
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func getPlacePosition(angle, height = 0):
	return Vector2(position.x + cos(angle) * (radius + height), position.y + sin(angle) * (radius + height));
