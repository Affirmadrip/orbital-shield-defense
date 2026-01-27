extends Node
class_name AudioManager

@onready var bgm: AudioStreamPlayer = $BGM
@onready var sfx_players: Array[AudioStreamPlayer] = [$SFX1, $SFX2, $SFX3, $SFX4]
var sfx_index := 0

@export var bgm_menu: AudioStream
@export var bgm_stage: AudioStream

@export var sfx_hover: AudioStream
@export var sfx_click: AudioStream
@export var sfx_bullet: AudioStream
@export var sfx_alien_dies: AudioStream
@export var sfx_clear: AudioStream
@export var sfx_gameover: AudioStream
@export var sfx_take_hit: AudioStream

func play_bgm_menu() -> void:
	_play_bgm(bgm_menu)

func play_bgm_stage() -> void:
	_play_bgm(bgm_stage)

func stop_bgm() -> void:
	if bgm.playing:
		bgm.stop()

func _play_bgm(stream: AudioStream) -> void:
	if stream == null:
		return
	# Avoid restarting the same track repeatedly
	if bgm.stream == stream and bgm.playing:
		return
	bgm.stream = stream
	bgm.play()

func play_sfx(stream: AudioStream) -> void:
	if stream == null:
		return
	var p := sfx_players[sfx_index]
	sfx_index = (sfx_index + 1) % sfx_players.size()
	p.stream = stream
	p.play()

func sfx_button_hover() -> void: play_sfx(sfx_hover)
func sfx_button_click() -> void: play_sfx(sfx_click)
func sfx_shoot() -> void: play_sfx(sfx_bullet)
func sfx_alien_die() -> void: play_sfx(sfx_alien_dies)
func sfx_stage_clear() -> void: play_sfx(sfx_clear)
func sfx_game_over() -> void: play_sfx(sfx_gameover)
func sfx_takehit() -> void: play_sfx(sfx_take_hit)

func _ready():
	print("AudioManager ready")
	print("AudioManager ready. Has play_takehit? ", has_method("play_takehit"))
	print("bgm_menu is null? ", bgm_menu == null)
	print("bgm_stage is null? ", bgm_stage == null)
