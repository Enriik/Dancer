extends Node2D

var _score := 10

var _radius_start := 150.0
var _radius_hit := 70.0
var _radius := _radius_start
var _offset := 8
var _misses := 0
var _last_beat: = 0.0
var _next_beat := 0.0
var _ok := 0.2
var _nice := 0.1
var _perfect := 0.05
var _half_beat := 0.483871

var _beat_delay := 4.0
var _speed := 0.0

var _beat_hit := true

var direction := Vector2.ZERO
var grid_size := 32
var snake := []
var head_pos := Vector2.ZERO
var current_tail_pos := Vector2.ZERO
var last_tail_pos := Vector2.ZERO
var can_move := true
onready var can_walk = true
onready var main = get_tree().get_current_scene()
var _msg : Dictionary

onready var tween = $Tween
onready var timer = $Timer
onready var anim = $AnimationPlayer
onready var tail = preload("res://scenes/Tail.tscn")
onready var dancer = preload("res://scenes/Dancer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	snake.append($Player)
# warning-ignore:return_value_discarded
	Events.connect("song_time",self,"_return_song_time")
	Events.connect("beat_incremented",self,"_return_beat")
	
# warning-ignore:unused_argument
func _process(delta):
	pass

#player moves on input
func _unhandled_key_input(event):
	if not _beat_hit and !tween.is_active():
		anim.play("out")
		_misses += 1
		return
		

	if event.is_action_released("ui_down"): return
	elif event.is_action_released("ui_left"): return 
	elif event.is_action_released("ui_right"): return
	elif event.is_action_released("ui_up"): return

	if event.is_action_pressed("ui_down", false):
		direction = Vector2.DOWN
	if event.is_action_pressed("ui_left", false):
		direction = Vector2.LEFT
	if event.is_action_pressed("ui_right", false):
		direction = Vector2.RIGHT
	if event.is_action_pressed("ui_up", false):
		direction = Vector2.UP
	
	Events.emit_signal("scored", {"score": _get_score()})
	last_tail_pos = head_pos + direction * grid_size
	
	if !tween.is_active():
		move(direction)

func move(dir: Vector2):
	_misses = 0
	for i in snake.size():	
		if i == 0:
			tween.interpolate_property(
				snake[i],
				"position",
				head_pos,
				last_tail_pos,
				timer.wait_time,
				Tween.TRANS_SINE,
				Tween.EASE_OUT)
			tween.start()
			last_tail_pos = head_pos
			head_pos += dir * grid_size
			current_tail_pos = head_pos
			
		else:
			current_tail_pos = snake[i].position
			tween.interpolate_property(
				snake[i],
				"position",
				current_tail_pos,
				last_tail_pos,
				timer.wait_time,
				Tween.TRANS_SINE,
				Tween.EASE_IN)	
			tween.start()
			last_tail_pos = current_tail_pos

func _on_Head_area_entered(area):
	if area.name == "Dancer":
		Events.emit_signal("scored", {"score": 5})
		var t = tail.instance()
		yield(tween,"tween_all_completed")
		t.position = snake.back().position - direction * grid_size
		call_deferred("add_child",t)
		snake.append(t)
	
func _get_score() -> int:
	if abs(_radius_hit - _radius) < _offset:
		return _score
	return 0

func _allow_movement(msg: Dictionary):
	var _beats_per_second: float = msg.bps
	
	_beat_hit = true
	yield(get_tree().create_timer(_beats_per_second/4),"timeout")
	_beat_hit = false
	

