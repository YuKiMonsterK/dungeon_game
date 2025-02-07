class_name Enemy
extends CharacterBody2D

enum Direction{
	LEFT = -1,
	RIGHT = +1
}
@export var direction := -Direction.LEFT:
	set(v):
		direction = v
		if not is_node_ready():
			await ready
@export var max_speed : float = 30

@onready var graphics = $Graphics
@onready var collision_shape_2d = $CollisionShape2D
