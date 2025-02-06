class_name Interactable
extends Area2D
@onready var player = $player
signal interacted


func _init():
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(1,true)
	
	body_entered.connect(on_body_entered)
	body_exited.connect(on_body_exited)

func interact():
	print("[Interacted] %s" % name)
	interacted.emit()

func on_body_entered():
	player.interacting_with = self

func on_body_exited():
	player.interacting_with = null
