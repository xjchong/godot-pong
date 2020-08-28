extends Node


const MAX_PLAYERS: int = 8
const BUS: String = "master"

var _available_audio_players = []
var _queue = []


func _ready():
	for i in MAX_PLAYERS:
		var audio_player := AudioStreamPlayer.new()
		
		add_child(audio_player)
		_available_audio_players.append(audio_player)
		audio_player.connect("finished", self, "_on_stream_finished", [audio_player])
		audio_player.bus = BUS
		
		
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
