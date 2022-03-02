extends Node2D

var direction = Vector2.ZERO
var grid_size = 32
var snake = []
var head_pos = Vector2.ZERO
var current_tail_pos = Vector2.ZERO
var last_tail_pos = Vector2.ZERO

onready var tween = $Tween
onready var timer = $Timer
onready var tail = preload("res://scenes/Tail.tscn")
onready var dancer = preload("res://scenes/Dancer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	snake.append($Player)

#func _unhandled_input(event):
#	if event.is_action_pressed("ui_down"):
#		direction = Vector2.DOWN
#	if event.is_action_pressed("ui_left"):
#		direction = Vector2.LEFT
#	if event.is_action_pressed("ui_right"):
#		direction = Vector2.RIGHT
#	if event.is_action_pressed("ui_up"):
#		direction = Vector2.UP
#
#	last_tail_pos = head_pos + direction * grid_size
#
#	if !tween.is_active():
#		move(direction)

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_pressed("ui_down"):
		direction = Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		direction = Vector2.UP
		
	last_tail_pos = head_pos + direction * grid_size
	
	if !tween.is_active():
		move(direction)

func move(dir: Vector2):
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
		var t = tail.instance()
		yield(tween,"tween_all_completed")
		t.position = snake.back().position - direction * grid_size
		call_deferred("add_child",t)
		snake.append(t)
	
