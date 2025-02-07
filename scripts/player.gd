extends CharacterBody2D

const Speed = 100.0
const acceleration = Speed / 0.2
var interacting_with : Interactable
var rotating = false
var rotation_target = 136
var rotation_speed = 6   
var direction_x = 0
var position_target = 0
var attack_combo = 0

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var interact_icon = $interactIcon
@onready var animated_sword = $sword/AnimatedSprite2D
@onready var collision_sword = $sword/CollisionShape2D

func tick_physics():
	interact_icon.visible = interacting_with != null

func _physics_process(_delta): #每幀執行
	
	if not animated_sprite_2d.flip_h and not rotating and attack_combo != 2:
		animated_sword.rotation_degrees = -132
		rotation_target = 136
		animated_sword.position.x = animated_sprite_2d.position.x-4
		position_target = animated_sprite_2d.position.x + 20
	elif animated_sprite_2d.flip_h and not rotating and attack_combo != 2:
		animated_sword.rotation_degrees = 132
		rotation_target = -136
		animated_sword.position.x = animated_sprite_2d.position.x+4
		position_target = animated_sprite_2d.position.x - 20
	#移動方面
	collision_sword.rotation_degrees = animated_sword.rotation_degrees 
	animated_sword.flip_h = animated_sprite_2d.flip_h
	collision_sword.position.x = animated_sword.position.x
	collision_sword.position.y = animated_sword.position.y
	
	direction_x = Input.get_axis("ui_left", "ui_right") #平常為0，按時為-1或1
	
	if direction_x == 1:              #right
		velocity.x = move_toward(velocity.x,direction_x * Speed,acceleration)
		animated_sprite_2d.play("runLR")
		
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.z_index = 0
		
	elif direction_x == -1:           #left
		velocity.x = move_toward(velocity.x,direction_x * Speed,acceleration)
		animated_sprite_2d.play("runLR")
		
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.z_index = 1

		
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		
	var direction_y = Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = move_toward(velocity.y,direction_y * Speed,acceleration)
		animated_sprite_2d.play("runLR")
	else:
		velocity.y = move_toward(velocity.y, 0, Speed)
	if not direction_x and not direction_y:
		animated_sprite_2d.play("default")
	move_and_slide()
	

		
	#戰鬥方面
	
	
	if rotating and attack_combo != 2:

		if not animated_sprite_2d.flip_h:
				animated_sword.position.x = animated_sprite_2d.position.x +10
		else:
				animated_sword.position.x = animated_sprite_2d.position.x -6
		animated_sword.position.y = animated_sprite_2d.position.y+4
		animated_sword.rotation_degrees = move_toward(animated_sword.rotation_degrees, rotation_target,rotation_speed)
		
		if animated_sword.animation != "attack1" :
			animated_sword.play("attack1")
		if Input.is_action_just_pressed("ui_attack") :
			attack_combo += 1
			print("attack_combo + 1, attack_combo = %d"%attack_combo)
		if is_equal_approx(animated_sword.rotation_degrees, rotation_target) and attack_combo == 1:
			rotating = false
			animated_sword.play("default")
			animated_sword.position.y = animated_sprite_2d.position.y+8
			attack_combo = 0
			if not animated_sprite_2d.flip_h :
				animated_sword.rotation_degrees = -132
				animated_sword.position.x = animated_sprite_2d.position.x-4
			elif animated_sprite_2d.flip_h :
				animated_sword.rotation_degrees = 132
				animated_sword.position.x = animated_sprite_2d.position.x+4
	if attack_combo == 2:
	
		animated_sword.play("attack2")
		if not animated_sprite_2d.flip_h:
			animated_sword.rotation_degrees = 90
			animated_sword.position.x = move_toward(animated_sword.position.x,position_target,0.5)
		else:
			animated_sword.rotation_degrees = -90
			animated_sword.position.x = move_toward(animated_sword.position.x,position_target,0.5)
		if is_equal_approx(animated_sword.position.x, position_target):
			rotating = false
			animated_sword.play("default")
			animated_sword.position.y = animated_sprite_2d.position.y+8
			attack_combo = 0
			if not animated_sprite_2d.flip_h :
				animated_sword.rotation_degrees = -132
				animated_sword.position.x = animated_sprite_2d.position.x-4
			elif animated_sprite_2d.flip_h :
				animated_sword.rotation_degrees = 132
				animated_sword.position.x = animated_sprite_2d.position.x+4
		
func _input(_event):     #按任意鍵時執行
	
	#移動方面
	
	
	#戰鬥方面
	if Input.is_action_just_pressed("ui_attack") and not rotating:
		if not animated_sprite_2d.flip_h:
			animated_sword.rotation_degrees = 46
		else:
			animated_sword.rotation_degrees = -46
		rotating = true
		
