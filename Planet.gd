extends Node2D


const GRAVITY_COLLIDER_SHAPE2D_NAME = "CollisionShape2D";

const SCALE_RADIUS_MULTIPLIER = 200;
const GRAVITY_COLLIDER_OFFSET = 100;

export (float) var gravity;
export (float) var revolutionTime;
export (NodePath) var _referencePlanet;

var referencePlanet;
var orbitalRadius;
var orbitalAngle;

var radius;
var perimeter;

var doOrbit;

func _ready():
	radius = scale.x * SCALE_RADIUS_MULTIPLIER;
	perimeter = radius * TAU;
	
	var collisionShape = CollisionShape2D.new();
	collisionShape.shape = CircleShape2D.new();
	collisionShape.shape.set("radius", (radius + GRAVITY_COLLIDER_OFFSET) / scale.x);
	$GravityCollider.add_child(collisionShape);
	collisionShape.set_name(GRAVITY_COLLIDER_SHAPE2D_NAME);
	
	if _referencePlanet:
		referencePlanet = get_node(_referencePlanet);
		orbitalRadius = position.distance_to(referencePlanet.position);
		orbitalAngle = position.angle_to_point(referencePlanet.position);
		setOrbitNormal();
	else:
		setOrbitVoid();
		
	
	pass

func _process(delta):
	doOrbit.call_func(delta);

func setOrbitVoid():
	doOrbit = funcref(self, "doOrbitVoid");

func doOrbitVoid(delta):
	
	pass;
	
func setOrbitNormal():
	doOrbit = funcref(self, "doOrbitNormal");
	
func doOrbitNormal(delta):
	orbitalAngle += delta /revolutionTime * TAU;
	position = referencePlanet.getOrbitPosition(orbitalAngle, orbitalRadius);
	pass;

func getPositionOnPlanet (angle):
	return (angle / TAU) * perimeter;

func getPlaceAngle(planetPosition):
	return planetPosition / perimeter * TAU;
	

func getPlacePosition(angle, height = 0):
	return Vector2(position.x + cos(angle) * (radius + height), position.y + sin(angle) * (radius + height));
	
func getOrbitPosition(angle, orbitalRadius):
	return Vector2(position.x + cos(angle) * orbitalRadius, position.y + sin(angle) * orbitalRadius);