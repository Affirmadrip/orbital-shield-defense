extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var settings: Panel = $Settings
@onready var tutorial: Panel = $Tutorial
@onready var credits: Panel = $Credits


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_buttons.visible = true
	settings.visible = false
	tutorial.visible = false
	credits.visible = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/stage.tscn")


func _on_tutorial_pressed() -> void:
	print("Tutorial pressed")
	main_buttons.visible = false
	tutorial.visible = true

func _on_back_tutorial_pressed() -> void:
	_ready()

func _on_settings_pressed() -> void:
	print("Settings pressed")
	main_buttons.visible = false
	settings.visible = true

func _on_back_settings_pressed() -> void:
	_ready()

func _on_credits_pressed() -> void:
	print("Settings pressed")
	main_buttons.visible = false
	credits.visible = true
	
func _on_back_credits_pressed() -> void:
	_ready()


func _on_exit_pressed() -> void:
	get_tree().quit()
