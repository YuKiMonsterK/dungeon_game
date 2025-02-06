extends Enemy

@onready var left_cheaker = $Graphics/Left_cheaker
@onready var right_cheaker = $Graphics/Right_cheaker
@onready var animated_sprite_2d = $Graphics/AnimatedSprite2D


func _process(delta):
	if right_cheaker.is_colliding():
		direction = Direction.LEFT
		animated_sprite_2d.flip_h = true
	if left_cheaker.is_colliding():
		direction = Direction.RIGHT
		animated_sprite_2d.flip_h = false
	position.x += direction * max_speed * delta

