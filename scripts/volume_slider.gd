extends HSlider

@export var bus_name: String = "Music"
@export var min_db: float = -40.0 

func _ready() -> void:
	if not value_changed.is_connected(_on_value_changed):
		value_changed.connect(_on_value_changed)

	_on_value_changed(value)

func _on_value_changed(v: float) -> void:
	var idx: int = AudioServer.get_bus_index(bus_name)
	if idx == -1:
		push_warning("Bus not found: " + bus_name)
		return

	var t: float = clampf(v, 0.0, 1.0)
	var db: float = lerpf(min_db, 0.0, t)

	AudioServer.set_bus_volume_db(idx, db)
	AudioServer.set_bus_mute(idx, t <= 0.001)
