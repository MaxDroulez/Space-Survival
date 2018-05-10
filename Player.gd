extends Node2D

const JUMP_FORCE = 100;

const ZOOM_STRENGTH = 0.1;
const MAX_ZOOM = 0.3;

export (float) var SPEED;
export (NodePath) var STARTING_PLANET;

var currentPlanet;
var angleOnPlanet = 0;
var planetPosition = 0;
var verticalHeight = 0;
var verticalVelocity = 0;

var doAction;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	currentPlanet = get_node(STARTING_PLANET);
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
	
#	if(Input.is_action_just_pressed("dezoom")):
#		$Camera2D.zoom += 0.1;
#		print($Camera2D.zoom);
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
#	print(planetPosition);
	rotation = currentPlanet.getPlaceAngle(planetPosition);
	position = currentPlanet.getPlacePosition(rotation, verticalHeight);
	rotation += PI / 2;
#	print(rotation);
	
