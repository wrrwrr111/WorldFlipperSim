extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var type = 'gold'
# Called when the node enters the scene tree for the first time.
func _ready():
	$laser.play('laser')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func hit():
	self.get_parent().remove_child(self)


