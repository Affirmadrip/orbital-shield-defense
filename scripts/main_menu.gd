extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var settings: Panel = $Settings
@onready var tutorial: Panel = $Tutorial
@onready var credits: Panel = $Credits

func _ready() -> void:
	Audio.play_bgm_menu()

	main_buttons.visible = true
	settings.visible = false
	tutorial.visible = false
	credits.visible = false


func _on_start_pressed() -> void:
	Audio.sfx_button_click()
	Audio.stop_bgm()
	get_tree().change_scene_to_file("res://scenes/stage.tscn")


func _on_tutorial_pressed() -> void:
	Audio.sfx_button_click()
	main_buttons.visible = false
	tutorial.visible = true


func _on_back_tutorial_pressed() -> void:
	Audio.sfx_button_click()
	_ready()


func _on_settings_pressed() -> void:
	Audio.sfx_button_click()
	main_buttons.visible = false
	settings.visible = true


func _on_back_settings_pressed() -> void:
	Audio.sfx_button_click()
	_ready()


func _on_credits_pressed() -> void:
	Audio.sfx_button_click()
	main_buttons.visible = false
	credits.visible = true


func _on_back_credits_pressed() -> void:
	Audio.sfx_button_click()
	_ready()


func _on_exit_pressed() -> void:
	Audio.sfx_button_click()
	get_tree().quit()


# Hover SFX (connect mouse_entered signals to this)
func _on_button_hover() -> void:
	Audio.sfx_button_hover()
