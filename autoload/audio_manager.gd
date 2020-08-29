extends Node


const MAX_PLAYERS: int = 8
const MASTER_BUS: String = "master"
const BACKGROUND_BUS: String = "background"

var _background_audio_player := AudioStreamPlayer.new()
var _available_audio_players = []
var _queue = []


func _ready():
	for i in MAX_PLAYERS:
		var audio_player := AudioStreamPlayer.new()
		
		add_child(audio_player)
		_available_audio_players.append(audio_player)
		audio_player.connect("finished", self, "_on_stream_finished", [audio_player])
		audio_player.bus = MASTER_BUS
		
	add_child(_background_audio_player)
	_background_audio_player.bus = BACKGROUND_BUS
		
		
func _process(delta):
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
		_background_audio_player.stop()
