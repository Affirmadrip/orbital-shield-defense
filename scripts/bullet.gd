extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var damage: int = 1
var speed : float = 100

func _ready() -> void:
	animated_sprite_2d.play("default")
	
	
func scale(heldlength: int) -> void:
	animated_sprite_2d.scale *=  heldlength
