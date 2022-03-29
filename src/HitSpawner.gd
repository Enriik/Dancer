extends Node

# If `true`, the spawner is actively spawning beats. We use it in `_spawn_beat()` below.
export var enabled := true


func _ready() -> void:
	Events.connect("beat_incremented", self, "_spawn_beat")


# Spawns a button the player can tap. Expects a dictionary with the form
# {half_beat = int, bps = float}.
# This gives us all the information we need to selectively spawn buttons at
# specific rhythmic moments in the music.
func _spawn_beat(msg: Dictionary) -> void:
	# If the spawner is not enabled, we just return from the function and spawn
	# nothing.
	if not enabled:
		return
