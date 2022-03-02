extends Node2D

var points = 0
var row = 12
var col = 12
var size = Vector2(32,32)
var grid_size = 32
var colors = [Color.blueviolet,Color.hotpink]

onready var dancer = preload("res://scenes/Dancer.tscn")

func _ready():
	randomize()
	var d = dancer.instance()
	d.connect("dancer_joined",self,"spawn_new")
	d.position = Vector2(randi() % 12, randi() % 12) * size
	add_child(d)
	d.visible = true

func _draw():
	for r in row:
		for c in col:
			draw_rect(
			Rect2(c * size.x, 
			r * size.y, 
			size.x, 
			size.y), 
			colors[(c+r) % len(colors)])

func spawn_dancer():
	randomize()
	var d = dancer.instance()
	d.connect("dancer_joined",self,"spawn_new")
	d.position = Vector2(randi() % 12, randi() % 12) * size
	call_deferred("add_child",d)
	d.visible = true

func spawn_new():
	points += 5
	spawn_dancer()
