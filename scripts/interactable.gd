class_name Interactable
extends Area2D

signal interacted
@export var dialogue_resource: DialogueResource
var dialogue_title : String

func _init():
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, true)
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _ready():
	dialogue_title = name
func interact():
	print("[Interacted] %s" % name)
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, dialogue_title)
	interacted.emit()

func _on_body_entered(player: Player):
	player.interacting_with = self

func _on_body_exited(player: Player):
	player.interacting_with = null
