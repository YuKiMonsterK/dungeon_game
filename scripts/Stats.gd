class_name stats
extends Node

@export var max_health : int = 10

@onready var health: int = max_health #預設先初始化一般變量，onready則是使他最後加載
