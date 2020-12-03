extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (int) var gold_chance = 10
export var type = 'sliver_ball' # gold rainbow
signal ball_fall
# Called when the node enters the scene tree for the first time.
func _ready():
	if randi()%100 < gold_chance:
		$AnimatedSprite.play('gold')
		type = 'gold_ball'
	else:
		$AnimatedSprite.play('sliver')
		type = 'sliver_ball'
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
export (int) var gravity = 1000
var time_speed = 1
var speed = 0
var ori_velocity = Vector2()
var velocity = Vector2()
func _physics_process(delta):
	
	speed += gravity * delta 
	ori_velocity.y += speed * delta
	
	var near_nodes_arr = get_layer_node(180,get_position())
	time_speed = 1
	for i in near_nodes_arr:
		if i.collider.type == 'gold' || i.collider.type == 'rainbow':
			if(position.y < i.collider.position.y):
				time_speed = 0.3
			
	velocity = ori_velocity * time_speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		match collision.collider.type:
			'sliver':
				ori_velocity = velocity.bounce(collision.normal) * 0.5
			'gold':
				if(type == 'sliver_ball'):
					type = 'gold_ball'
					$AnimatedSprite.play('gold')
				else:
					change_rainbow()
			'rainbow':
				change_rainbow()
			'wall':
				ori_velocity = velocity.bounce(collision.normal) * 0.5
		if collision.collider.has_method("hit"):
			collision.collider.hit()
		
		
	emit_signal('ball_fall',self)



func change_rainbow():
	type = 'rainbow_ball'
	$AnimatedSprite.play('rainbow')
	self.get_parent().change_rainbow()

var shape_cicle := CircleShape2D.new()
func get_layer_node(radius, pos:Vector2):
	# 设置碰撞形状
	shape_cicle.radius = radius
	
	# 新建 Physics2DShapeQueryParameters 并配置
	var p = Physics2DShapeQueryParameters.new()
	p.set_shape(shape_cicle)		# 设置碰撞形状
	p.collide_with_areas = true		# 监测 Area 区域
	p.collision_layer = 1			# 对应被检测物体的 layer 层级
	p.transform = Transform2D(0, pos)	# 设置碰撞的位置	
	
	# 检测碰撞
	var arr = get_world_2d().direct_space_state.intersect_shape(p)
	return arr	# 返回碰撞结果
