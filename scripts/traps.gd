extends AnimatedSprite2D
@onready var animated_sprite_2d = $"."

var unlock = false
func _ready():
	pass # Replace with function body.


func _process(_delta):
	animated_sprite_2d.play("default")


func _on_area_2d_area_entered(area):
	print("in")
