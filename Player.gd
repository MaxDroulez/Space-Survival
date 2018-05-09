extends Node2D

export (float) var SPEED;
export (NodePath) var currentPlanet;
var angleOnPlanet = 0;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if(Input.is_action_pressed("ui_left")):
		angleOnPlanet -= SPEED * delta;
	if(Input.is_action_pressed("ui_right")):
		angleOnPlanet += SPEED * delta;
		
	print(angleOnPlanet);
	pass
