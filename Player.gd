extends Node2D


const ZOOM_STRENGTH = 0.1;
const MAX_ZOOM = 0.3;

export (float) var SPEED;
export (float) var JUMP_FORCE;
export (NodePath) var STARTING_PLANET;

var currentPlanet;
var planetPosition = 0;
var verticalHeight = 0;
var verticalVelocity = 0;

var doAction;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	currentPlanet = get_node(STARTING_PLANET);
	print(currentPlanet);
	setStateGrounded();

func _input(event):
	if (event.is_action("dezoom")):
		var camera = $Camera2D;
		camera.zoom.x += ZOOM_STRENGTH;
		camera.zoom.y += ZOOM_STRENGTH;
	
	if(event.is_action("zoom")):
		var camera = $Camera2D;
		camera.zoom.x -= ZOOM_STRENGTH;
		camera.zoom.y -= ZOOM_STRENGTH;
		if(camera.zoom.x < MAX_ZOOM):
			camera.zoom.x = MAX_ZOOM;
			camera.zoom.y = MAX_ZOOM;


func _process(delta):
	if(Input.is_action_pressed("ui_left")):
#		angleOnPlanet -= SPEED * delta;
		planetPosition -= SPEED * delta;
		$AnimatedSprite.flip_h = true;
		
	if(Input.is_action_pressed("ui_right")):
#		angleOnPlanet += SPEED * delta;
		planetPosition += SPEED * delta;
		$AnimatedSprite.flip_h = false;
		
	doAction.call_func(delta);
	
	placeOnPlanet();


func setStateGrounded():
	doAction = funcref(self, "grounded");

func grounded(delta):
	if(Input.is_action_pressed("jump")):
		verticalVelocity = JUMP_FORCE;
		setStateInAir();

func setStateInAir():
	doAction = funcref(self, "inAir");

func inAir(delta):
	verticalVelocity -= currentPlanet.gravity * delta;
	verticalHeight += verticalVelocity * delta
	
	if(verticalHeight <= 0):
		verticalHeight = 0;
		setStateGrounded();

func placeOnPlanet():
	rotation = currentPlanet.getPlaceAngle(planetPosition);
	position = currentPlanet.getPlacePosition(rotation, verticalHeight);
	rotation += PI / 2;
	
func _on_GravityCollider_area_entered(area):
	currentPlanet = area.get_node("../");
	verticalHeight = position.distance_to(currentPlanet.position) - currentPlanet.radius;
	verticalVelocity = 0;
	planetPosition = currentPlanet.getPositionOnPlanet(position.angle_to_point(currentPlanet.position));
	setStateInAir();
	
	pass # replace with function body

func _on_GravityCollider_area_exited(area):
	print("out");
	pass # replace with function body
