extends Area2D
class_name Alien

enum AlienType { RED, PURPLE, GREY }

@export var alien_type: AlienType = AlienType.RED:
	set(value):
		alien_type = value
		if is_inside_tree():
			_apply_type_stats()

@export var tex_red: Texture2D
@export var tex_purple: Texture2D
@export var tex_grey: Texture2D

var target_pos: Vector2 = Vector2.ZERO

var speed: float = 120.0
var damage_to_barrier: int = 5

var max_hp: int = 1
var hp: int = 1

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	_apply_type_stats()

func set_target(pos: Vector2) -> void:
	target_pos = pos


func _process(delta: float) -> void:
	var dir := (target_pos - global_position).normalized()
	global_position += dir * speed * delta

	if dir.length() > 0.0:
		rotation = dir.angle() + deg_to_rad(90)


func _apply_type_stats() -> void:
	match alien_type:
		AlienType.RED:
			sprite.texture = tex_red
			speed = 140.0
			damage_to_barrier = 3
			max_hp = 10
			sprite.scale = Vector2(0.1, 0.1)

		AlienType.PURPLE:
			sprite.texture = tex_purple
			speed = 115.0
			damage_to_barrier = 7
			max_hp = 25
			sprite.scale = Vector2(0.15, 0.15)

		AlienType.GREY:
			sprite.texture = tex_grey
			speed = 95.0
			damage_to_barrier = 15
			max_hp = 60
			sprite.scale = Vector2(0.2, 0.2)

	hp = max_hp

func take_damage(dmg: int) -> void:
	hp -= dmg
	if hp <= 0:
		queue_free()
