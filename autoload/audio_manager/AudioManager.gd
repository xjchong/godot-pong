extends Node


enum Bus { MASTER, BACKGROUND, SOUND_EFFECTS }


const DEFAULT_SOUND_VOLUME_PERCENT = 0.7
const DEFAULT_MUSIC_VOLUME_PERCENT = 0.5
const MAX_PLAYERS: int = 8
const BACKGROUND_BUS: String = "Background"
const SOUND_EFFECTS_BUS: String = "SoundEffects"

var _available_audio_players = []
var _queue = []

onready var _background_audio_player := $BackgroundAudio
onready var _background_volume_tween: Tween = \
		$BackgroundAudio/BackgroundVolumeTween


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	_load_volume_settings()
	
	for i in MAX_PLAYERS:
		var audio_player := AudioStreamPlayer.new()
		
		add_child(audio_player)
		_available_audio_players.append(audio_player)
		audio_player.connect("finished", self, "_on_stream_finished", [audio_player])
		audio_player.bus = SOUND_EFFECTS_BUS
		
		
func _process(_delta):
	if _queue.empty() or _available_audio_players.empty():
		return
		
	var next_audio_player = _available_audio_players.pop_front()
	
	next_audio_player.stream = load(_queue.pop_front())
	next_audio_player.play()
	
	
func _on_stream_finished(audio: AudioStreamPlayer):
	_available_audio_players.append(audio)
	
	
func play(sound_path: String):
	_queue.append(sound_path)


func start_loop(sound_path: String):
	var audio_resource = load(sound_path)

	if _background_audio_player.stream == audio_resource:
		return

	_background_audio_player.stream = audio_resource
	_background_audio_player.play()
	
	
func end_loop():
	if _background_audio_player.playing:
		var current_volume_db = _background_audio_player.volume_db
		
		_background_volume_tween.interpolate_property(
			_background_audio_player, "volume_db", 
			_background_audio_player.volume_db, -80, 4.0
		)
		_background_volume_tween.start()
		yield(_background_volume_tween, "tween_completed")
		_background_audio_player.stop()
		_background_audio_player.stream = null
		_background_audio_player.volume_db = current_volume_db
		
		
func update_volume(bus: int, volume_percent: float):
	AudioServer.set_bus_volume_db(bus, linear2db(volume_percent))


func _load_volume_settings():
	var background_volume_percent = SettingsManager.load_setting(
		"menu_music", "volume_percent", DEFAULT_MUSIC_VOLUME_PERCENT
	)
	
	var sound_effects_volume_percent = SettingsManager.load_setting(
		"sound_effects", "volume_percent", DEFAULT_SOUND_VOLUME_PERCENT
	)
	
	AudioServer.set_bus_volume_db(
		Bus.BACKGROUND, 
		linear2db(background_volume_percent)
	)
	
	AudioServer.set_bus_volume_db(
		Bus.SOUND_EFFECTS, 
		linear2db(sound_effects_volume_percent)
	)
	
