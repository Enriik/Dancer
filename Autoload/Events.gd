extends Node

# warning-ignore:unused_signal
signal beat_incremented(msg)
# warning-ignore:unused_signal
signal scored(msg)
# warning-ignore:unused_signal
signal song_time(msg)


var game_difficulty = ["easy","medium","hard"]
var game_difficulty_selected = 0
var game_param = {
	"easy":{"less_time":1.5,"max_time":0.3},
	"medium":{"less_time":1.4,"max_time":0.28},
	"hard":{"less_time":1.3,"max_time":0.26},
}
