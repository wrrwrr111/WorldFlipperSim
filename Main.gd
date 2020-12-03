extends Control

const Yin = preload('yin.tscn')
const Jin = preload('jin.tscn')
const Hong = preload('hong.tscn')
const Ball = preload('ball.tscn')
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var camera = $Camera2D


export (int) var silver_chance = 70
export (int) var gold_min = 3
export (int) var gold_more = 6
export (int) var rainbow_min = 0
export (int) var rainbow_more = 3
export (bool) var full_auto = false
var sum = 0
var silver_num = 0
var gold_num = 0
var rainbow_num = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/silver_chance.value = silver_chance
	$CanvasLayer/gold_more.value = gold_more
	$CanvasLayer/rainbow_more.value = rainbow_more

	
var pin_arr = []
var ball

func set_ball(pos):
	for i in pin_arr:
		if i:i.free()
	pin_arr = []
	if ball:ball.queue_free()
	camera.set_position(Vector2(0,0))
	
	ball = Ball.instance()
	ball.connect('ball_fall',self,"_on_ball_fall")
	ball.set_position(pos)
	add_child(ball)
	for i in 4:
		for j in 15:
			if randi()%100 < silver_chance:
				var yin = Yin.instance()
				var x = 48+150*i + (j%2)*75
				var y = 500+100*j
				yin.set_position(Vector2(x,y))
				add_child(yin)
				pin_arr.append(yin)
	for i in randi()%gold_more:
		var jin = Jin.instance()
		jin.set_position(Vector2(randi()%600,800+randi()%1200))
		add_child(jin)
		pin_arr.append(jin)
	for i in randi()%rainbow_more:
		var hong = Hong.instance()
		hong.set_position(Vector2(randi()%600,1200+randi()%800))
		add_child(hong)
		pin_arr.append(hong)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if(event.position.x >0 && event.position.x<640 && event.position.y<300):
				set_ball(event.position)

func change_rainbow():
	for i in pin_arr:
		i.queue_free()
	pass

func _on_ball_fall(ball):
	var pos = ball.position
	if pos.y > 500 && pos.y < 1500:
		camera.set_position(Vector2(0,pos.y-500))
	elif pos.y > 2000:
		match ball.type:
			'silver_ball':
				silver_num += 1
			'gold_ball':
				gold_num += 1
			'rainbow_ball':
				rainbow_num += 1
		sum += 1
		var text = 'sum: '+str(sum)
		text += '\nsilver_num: '+ str(silver_num)
		text += '\ngold_num: '+ str(gold_num)
		text += '\nrainbow_num: '+str(rainbow_num)
		text += '\nrainbow_rate: '+str(float(rainbow_num)/float(sum))
		$CanvasLayer/Label6.text = text
		ball.queue_free()
		if full_auto:
			set_ball(Vector2(randi()%640,randi()%300))


func _on_silver_chance_value_changed(value):
	silver_chance = int(value)
	pass # Replace with function body.



func _on_gold_more_value_changed(value):
	gold_more = int(value)
	pass # Replace with function body.



func _on_rainbow_more_value_changed(value):
	rainbow_more = int(value)
	pass # Replace with function body.


func _on_CheckBox_toggled(button_pressed):
	full_auto = button_pressed
	pass # Replace with function body.
