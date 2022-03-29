extends Node2D

var points := 0
var row := 12
var col := 12
var size := Vector2(32,32)
var grid_size := 32
var colors := [Color.coral,Color.aquamarine]

export(int) var music_bpm = 124
onready var bpm = (60000/music_bpm)*0.001
var time = 0
var global_time = 0
var bpm_count = 0
var wrong_count = 0

signal pulse

export var enabled := true

onready var dancer := preload("res://scenes/Dancer.tscn")

func _ready():
	randomize()
	var d = dancer.instance()
	d.connect("dancer_joined",self,"spawn_new")
	d.position = Vector2(randi() % 12, randi() % 12) * size
	add_child(d)
	d.visible = true
	
# warning-ignore:return_value_discarded
	Events.connect("beat_incremented", self, "_spawn_beat")

func _draw():
	for r in row:
		for c in col:
			draw_rect(
			Rect2(c * size.x, 
			r * size.y, 
			size.x, 
			size.y), 
			colors[(c+r) % len(colors)])

func _process(delta: float) -> void:
	time += 1*delta
	global_time +=1*delta
	if time >= bpm:
		time = 0
		bpm_count += 1
		pulse()

func pulse():
#	$damier/Sprite.rect_position.x += damier_pos
#	$damier/color_alpha.interpolate_property($damier/Sprite,"self_modulate",
#		Color(dam_c.r,dam_c.g,dam_c.v,0.6),Color(dam_c.r,dam_c.g,dam_c.v,0.4),speed,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
#	$damier/color_alpha.start()
#	$tween/cam_scale.interpolate_property($player/Camera2D,"zoom",
#		Vector2(1.025,1.025),Vector2(1,1),speed,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
#	$tween/vignette_scale.interpolate_property($canv/vignette,"scale",
#		Vector2(8.7,5.5),Vector2(10,6.5),speed,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
#	$tween/cam_scale.start()
#	$tween/vignette_scale.start()
#	emit_signal("pulse")
#	$canv/bpm.text = "pulsations : "+str(bpm_count)
	pass

func can_walk():
	if time >= bpm/Events.game_param.get(Events.game_difficulty[Events.game_difficulty_selected]).get("less_time") or time <= bpm*Events.game_param.get(Events.game_difficulty[Events.game_difficulty_selected]).get("max_time"):
		return true
#	$canv/fautes.text = "erreurs : "+str(wrong_count)

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


func _on_Outbounds_area_entered(area):
	if area.name == "Player":
# warning-ignore:return_value_discarded
		get_tree().reload_current_scene()
		
func _spawn_beat(msg: Dictionary) -> void:
	pass
#	print(msg.half_beat)
#	print(msg.bps)
