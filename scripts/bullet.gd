extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var player: Player
var damage: int = 1
var speed : float = 100
var velocity: Vector2
signal bullet_hitted(bullet_damage: int)

func _ready() -> void:
	animated_sprite_2d.play("default")
	monitoring = true
	monitorable = true
	
func scale_bullet(heldlength: float) -> void:
	self.scale *= heldlength
	
func set_player(current_player: Player ) -> void:
	player = current_player
	global_position = player.global_position
	rotation = player.rotation
	velocity = transform.y
	
func _physics_process(delta: float) -> void:
	position += velocity * speed * delta

	
func _on_area_entered(area: Area2D) -> void:
	if area is Alien:
		bullet_hitted.emit(damage)
		print("Hitted!")
