extends CharacterBody2D

@export var max_speed : float = 30
@onready var graphics = $Graphics
@onready var collision_shape_2d = $CollisionShape2D
@onready var collision_hitbox = $Graphics/HitBox/CollisionShape2D

func _process(_delta):
	collision_hitbox.disabled = true
