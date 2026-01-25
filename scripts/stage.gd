extends Node2D

@export var alien_scene: PackedScene

# UI Nodes
@onready var planet: Sprite2D = $Planet
@onready var barrier: Area2D = $Barrier
@onready var aliens_container: Node2D = $Aliens
@onready var hp_label: Label = $UI/HPLabel
@onready var hp_bar: ProgressBar = $UI/HPBar
@onready var timer_label: Label = $UI/TimerLabel
@onready var stage_label: Label = $UI/StageLabel

var current_stage: int = 1
var barrier_max_hp: int = 10
var barrier_hp: int
var is_game_over: bool = false
var is_stage_clear: bool = false

# Stage Logic
var stage_duration: float = 60.0
var stage_timer: float = 0.0
var spawn_queue: Array[int] = []
var current_spawn_interval: float = 1.0
var time_until_next_spawn: float = 0.0

# Configuration
var stage_config = {
	1: {
		"duration": 60.0,
		"aliens": {
			Alien.AlienType.RED: 30,
			Alien.AlienType.PURPLE: 5,
			Alien.AlienType.GREY: 2
		}
	},
	2: {
		"duration": 85.0,
		"aliens": {
			Alien.AlienType.RED: 45,
			Alien.AlienType.PURPLE: 10,
			Alien.AlienType.GREY: 4
		}
	}
}

func _ready() -> void:
	randomize()
	
	if has_node("Clear stage 1"): get_node("Clear stage 1").process_mode = Node.PROCESS_MODE_ALWAYS
	if has_node("Clear stage 2"): get_node("Clear stage 2").process_mode = Node.PROCESS_MODE_ALWAYS
	if has_node("GAME OVER"): get_node("GAME OVER").process_mode = Node.PROCESS_MODE_ALWAYS
	
	var view := get_viewport().get_visible_rect()
	var center := view.position + view.size / 2.0
	planet.global_position = center
	barrier.global_position = center
	
	barrier_hp = barrier_max_hp
	_update_hp_ui()
	
	start_stage(current_stage)

func start_stage(stage_num: int) -> void:
	current_stage = stage_num
	is_game_over = false
	is_stage_clear = false
	
	# Load config
	var config = stage_config.get(current_stage, stage_config[2])
	# Fallback/Scaling logic
	if not stage_config.has(current_stage):
		config = stage_config[2].duplicate(true)
		var diff = current_stage - 2
		config["duration"] += 10 * diff
		config["aliens"][Alien.AlienType.RED] += 5 * diff
		config["aliens"][Alien.AlienType.PURPLE] += 2 * diff
	
	stage_duration = config["duration"]
	stage_timer = stage_duration
	_generate_spawn_queue(config["aliens"])
	
	
	var spawn_duration = stage_duration * 0.90
	if spawn_queue.size() > 0:
		current_spawn_interval = spawn_duration / spawn_queue.size()
	else:
		current_spawn_interval = 2.0
		
	time_until_next_spawn = current_spawn_interval
	
	_update_stage_ui()

func _generate_spawn_queue(counts: Dictionary) -> void:
	spawn_queue.clear()
	for type in counts:
		var count = counts[type]
		for i in range(count):
			spawn_queue.append(type)
	spawn_queue.shuffle()

func _process(delta: float) -> void:
	if is_game_over or is_stage_clear:
		return
		
	stage_timer -= delta
	_update_timer_ui()
	
	# Check Loss: Time ran out
	if stage_timer <= 0:
		_check_game_over_condition()
		return
		
	_handle_spawning(delta)
	_check_stage_clear_condition()

func _handle_spawning(delta: float) -> void:
	if spawn_queue.is_empty():
		return
		
	time_until_next_spawn -= delta
	if time_until_next_spawn <= 0:
		var type = spawn_queue.pop_front()
		_spawn_alien(type)
		time_until_next_spawn = current_spawn_interval

func _spawn_alien(type: int) -> void:
	if alien_scene == null: return
	
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
	a.alien_type = type
	a.set_target(center)

func _check_stage_clear_condition() -> void:
	# Keep logic simple: if no spawns left AND no live aliens => Clear
	if spawn_queue.is_empty() and aliens_container.get_child_count() == 0:
		_on_stage_clear()

func _check_game_over_condition() -> void:
	# If timer hits 0 and enemies exist => Loss
	if aliens_container.get_child_count() > 0 or not spawn_queue.is_empty():
		_game_over()
	else:
		# Timer hit 0 but no enemies? That's a clear (edge case)
		_on_stage_clear()

func _on_stage_clear() -> void:
	is_stage_clear = true
	get_tree().paused = true
	# Show old panels for now to respect incremental approach
	var panel_name = "Clear stage " + str(current_stage)
	if has_node(panel_name):
		get_node(panel_name).visible = true
	else:
		# Fallback if no specific panel exists (for stage 3+)
		print("Stage Cleared! (No UI for this stage yet)")
		# Maybe just reuse generic logic in next step

func _game_over() -> void:
	is_game_over = true
	get_tree().paused = true
	if has_node("GAME OVER"):
		get_node("GAME OVER").visible = true

func damage_barrier(amount: int) -> void:
	barrier_hp = clamp(barrier_hp - amount, 0, barrier_max_hp)
	_update_hp_ui()
	if barrier_hp <= 0:
		_game_over()

func _update_hp_ui() -> void:
	hp_label.text = "Barrier HP: %d / %d" % [barrier_hp, barrier_max_hp]
	hp_bar.max_value = barrier_max_hp
	hp_bar.value = barrier_hp

func _update_timer_ui() -> void:
	if timer_label:
		timer_label.text = "%d" % ceil(max(0, stage_timer))

func _update_stage_ui() -> void:
	if stage_label:
		stage_label.text = "STAGE " + str(current_stage)

func _on_barrier_area_entered(area: Area2D) -> void:
	if area is Alien:
		damage_barrier(area.damage_to_barrier)
		area.queue_free()

# Button Listeners (to be connected from UI)
func _on_next_stage_button_pressed() -> void:
	get_tree().paused = false
	# Hide old panels
	for child in get_children():
		if child is Panel:
			child.visible = false
	start_stage(current_stage + 1)

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
