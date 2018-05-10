extends Node2D

const SCALE_RADIUS_MULTIPLIER = 200;

export (float) var gravity;

var radius;
var perimeter;


func _ready():
	
	radius = scale.x * SCALE_RADIUS_MULTIPLIER;
	print(radius);
#	
	perimeter = radius * TAU;
	print(perimeter);
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func getPlaceAngle(planetPosition):
	return planetPosition / perimeter * TAU;
	

func getPlacePosition(angle, height = 0):
	return Vector2(position.x + cos(angle) * (radius + height), position.y + sin(angle) * (radius + height));
