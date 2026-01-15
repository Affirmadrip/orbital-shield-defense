extends Control

var pause_toggle = false

func _ready() -> void:
	self.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause_and_unpause()
		
func pause_and_unpause():
	pause_toggle = !pause_toggle
	get_tree().paused = pause_toggle
	self.visible = pause_toggle


func _on_resume_button_pressed() -> void:
	pause_and_unpause()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false      
	get_tree().reload_current_scene()


func _on_mainmenu_button_pressed() -> void:
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
