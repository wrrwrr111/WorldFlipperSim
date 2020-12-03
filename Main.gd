extends Control

const Yin = preload('yin.tscn')
const Jin = preload('jin.tscn')
const Hong = preload('hong.tscn')
const Ball = preload('ball.tscn')
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var camera = $Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

export (int) var yin_chance = 70
var pin_arr = []
var ball = Ball.instance()

func set_ball(pos):
	for i in pin_arr:
		if i:i.free()
	pin_arr = []
	if ball:ball.free()
	camera.set_position(Vector2(0,0))
	
	ball = Ball.instance()
	ball.connect('ball_fall',self,"_on_ball_fall")
	ball.set_position(pos)
	add_child(ball)
	for i in 4:
		for j in 15:
			if randi()%100<yin_chance:
				var yin = Yin.instance()
				var x = 48+150*i + (j%2)*75
				var y = 500+100*j
				yin.set_position(Vector2(x,y))
				add_child(yin)
				pin_arr.append(yin)
	for i in randi()%5+2:
		var jin = Jin.instance()
		jin.set_position(Vector2(randi()%550,800+randi()%700))
		add_child(jin)
		pin_arr.append(jin)
	for i in randi()%3+1:
		var hong = Hong.instance()
		hong.set_position(Vector2(randi()%550,1200+randi()%300))
		add_child(hong)
		pin_arr.append(hong)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			set_ball(event.position)

func change_rainbow():
	for i in pin_arr:
		i.queue_free()
	pass

func _on_ball_fall(pos):
	if pos.y > 500 && pos.y < 1500:
		camera.set_position(Vector2(0,pos.y-500))
	elif pos.y > 2000:
		ball.queue_free()
	
