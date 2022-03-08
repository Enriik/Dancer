extends Node


export var bpm := 110

var _bps := 60 / bpm
var _hbps := _bps * 0.5

var _last_half_beat := 0

onready var _stream := $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	play_audio()


func _process(_delta: float) -> void:
	var time: float = (
		_stream.get_playback_position() 
		+ AudioServer.get_time_since_last_mix() 
		- AudioServer.get_output_latency()
		)
	# Calculate the current half-beat using
	# half-beats-per-second
	var half_beat := int(time / _hbps)

	if half_beat > _last_half_beat:
		_last_half_beat = half_beat

func play_audio() -> void:
	var time_delay := AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	yield(get_tree().create_timer(time_delay),"timeout")
	_stream.play()
