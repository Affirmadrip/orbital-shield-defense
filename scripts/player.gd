extends Node2D
@onready var bullet: Area2D = $Bullet
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var radius: float = 0.0

func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Fly_left"):
		pass
	if event.is_action_pressed("Fly_right"):
		pass
	if event.is_action_pressed("Fly_Faster"):
		pass
	if event.is_action_pressed("Shoot"):
		pass

func set_radius(rad:float)-> void:
	radius = rad
