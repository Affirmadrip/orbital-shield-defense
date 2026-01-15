extends Node2D

@export var alien_scene: PackedScene
@export var stage_number: int = 1

@export var stage_duration: float = 60.0
@export var barrier_max_hp: int = 300

@export var spawn_interval_stage1: float = 1.0
@export var spawn_interval_stage2: float = 0.6

@export var red_chance_stage1: int = 80
@export var red_chance_stage2: int = 65

@onready var planet: Sprite2D = $Planet
@onready var barrier: Area2D = $Barrier
@onready var aliens_container: Node2D = $Aliens
@onready var hp_label: Label = $UI/HPLabel
@onready var hp_bar: ProgressBar = $UI/HPBar 

var barrier_hp: int
var elapsed: float = 0.0
var spawn_timer: float = 0.0
var spawn_interval: float = 1.0

var grey_spawn_times: Array[float] = []
var greys_spawned: int = 0


func _ready() -> void:
	randomize()

	var view := get_viewport().get_visible_rect()
	var center := view.position + view.size / 2.0
	planet.global_position = center
	barrier.global_position = center

	barrier_hp = barrier_max_hp
	_update_hp_ui()

	if stage_number == 1:
		spawn_interval = spawn_interval_stage1
		grey_spawn_times = [stage_duration * 0.5]  # 1 grey
	else:
		spawn_interval = spawn_interval_stage2
		grey_spawn_times = [stage_duration * 0.35, stage_duration * 0.70]  # 2 greys


func _process(delta: float) -> void:
	elapsed += delta
	_spawn_greys_if_needed()
	_spawn_red_or_purple(delta)


func _spawn_red_or_purple(delta: float) -> void:
	if alien_scene == null:
		return

	spawn_timer += delta
	if spawn_timer < spawn_interval:
		return

	spawn_timer = 0.0

	var roll := randi() % 100
	if stage_number == 1:
		_spawn_alien(Alien.AlienType.RED if roll < red_chance_stage1 else Alien.AlienType.PURPLE)
	else:
		_spawn_alien(Alien.AlienType.RED if roll < red_chance_stage2 else Alien.AlienType.PURPLE)


func _spawn_greys_if_needed() -> void:
	if greys_spawned >= grey_spawn_times.size():
		return

	if elapsed >= grey_spawn_times[greys_spawned]:
		_spawn_alien(Alien.AlienType.GREY)
		greys_spawned += 1


func _spawn_alien(t: int) -> void:
	var a: Alien = alien_scene.instantiate()
	aliens_container.add_child(a)

	var center := planet.global_position

	var view := get_viewport().get_visible_rect()
	var left := view.position.x
	var top := view.position.y
	var right := view.position.x + view.size.x
	var bottom := view.position.y + view.size.y

	var edge := randi() % 4
	var spawn_pos := Vector2.ZERO
	match edge:
		0: spawn_pos = Vector2(randf_range(left, right), top - 40)
		1: spawn_pos = Vector2(randf_range(left, right), bottom + 40)
		2: spawn_pos = Vector2(left - 40, randf_range(top, bottom))
		3: spawn_pos = Vector2(right + 40, randf_range(top, bottom))

	a.global_position = spawn_pos
	a.alien_type = t
	a.set_target(center)


func damage_barrier(amount: int) -> void:
	barrier_hp = clamp(barrier_hp - amount, 0, barrier_max_hp)
	_update_hp_ui()


func _update_hp_ui() -> void:
	hp_label.text = "Barrier HP: %d / %d" % [barrier_hp, barrier_max_hp]

	hp_bar.max_value = barrier_max_hp
	hp_bar.value = barrier_hp


func _on_barrier_area_entered(area: Area2D) -> void:
	if area is Alien:
		damage_barrier(area.damage_to_barrier)
		area.queue_free()
