class_name Player extends Node2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var rotation_speed := 5
@export var center_node: Sprite2D
var current_rotation_speed = rotation_speed
var radius: float = 0.0
var angle: float = 0.0
#Bullets
var charging_bullet: bool = false
const bullet = preload("res://scenes/bullet.tscn")
const bullet_accumulation_rate = 0.075
var bullet_current_accumulation = 1

func _ready() -> void:
	radius = (center_node.texture.get_width() * center_node.scale.x) * 0.5
	global_position = Vector2(center_node.global_position.x, center_node.global_position.y + radius )
	angle = (global_position - center_node.global_position).angle()
	rotation = angle - PI/2
	
func _physics_process(delta) -> void:
	var direction = 0
	current_rotation_speed = rotation_speed
	if charging_bullet:
		bullet_current_accumulation += bullet_accumulation_rate
	if Input.is_action_pressed("Fly_left"):
		direction -= 1
	if Input.is_action_pressed("Fly_right"):
		direction += 1
	if Input.is_action_pressed("Fly_Faster"):
		current_rotation_speed = rotation_speed * 1.20
	#if Input.is_action_just_pressed("Shoot"):
		#shoots()
	angle += direction * current_rotation_speed * delta
	rotation = angle - PI/2
	global_position = center_node.global_position + (Vector2(cos(angle), sin(angle)) * radius)

func _input(event):
	if Input.is_action_pressed("Shoot"):
		if not charging_bullet:
			charging_bullet = true
	elif Input.is_action_just_released("Shoot"):
		if charging_bullet:
			charging_bullet = false
		Audio.sfx_shoot()
		create_bullet(bullet_current_accumulation)
		bullet_current_accumulation = 1.0
		
	
func create_bullet(bullet_scale_value: float) -> void:
	var new_bullet = bullet.instantiate()
	get_node("/root/").add_child(new_bullet)
	new_bullet.set_player(self)
	var new_damage = (new_bullet.damage + (bullet_scale_value* 1.9)) 
	new_bullet.damage = new_damage
	new_bullet.scale_bullet(bullet_scale_value)
	
	
	
