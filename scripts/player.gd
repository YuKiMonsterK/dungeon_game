extends CharacterBody2D

const Speed = 100.0
const acceleration = Speed / 0.2
var interacting_with : Interactable
var rotating = false
var rotation_target = 136
var direction_x = 0
var position_target = 0
var attack_combo = 0
var hurt_target = 0

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var interact_icon = $interactIcon
@onready var animated_sword = $HitBox/AnimatedSprite2D
@onready var collision_sword = $HitBox/CollisionShape2D
@onready var hurt_box = $HurtBox
@onready var collision_hurt_box = $HurtBox/CollisionShape2D
@onready var collision_sword_2 = $HitBox/CollisionShape2D2
@onready var Stats = $stats
@onready var camera_2d = $Camera2D
@onready var collision_shape_2d = $CollisionShape2D

signal attack_flip(flip)

func tick_physics():
	interact_icon.visible = interacting_with != null


func _physics_process(_delta): #每幀執行
	
	if not animated_sprite_2d.flip_h and not rotating and attack_combo != 2:
		animated_sword.rotation_degrees = -170
		rotation_target = 136
		animated_sword.position.x = animated_sprite_2d.position.x-4
		position_target = animated_sprite_2d.position.x + 20
		collision_sword.position.x = animated_sprite_2d.position.x +9
		collision_sword_2.position.x = animated_sprite_2d.position.x +14
		animated_sword.frame = animated_sprite_2d.frame
	elif animated_sprite_2d.flip_h and not rotating and attack_combo != 2:
		animated_sword.rotation_degrees = 170
		rotation_target = -136
		animated_sword.position.x = animated_sprite_2d.position.x+4
		position_target = animated_sprite_2d.position.x - 20
		collision_sword.position.x = animated_sprite_2d.position.x -9
		collision_sword_2.position.x = animated_sprite_2d.position.x - 14
		animated_sword.frame = animated_sprite_2d.frame
	#移動方面
	
	animated_sword.flip_h = animated_sprite_2d.flip_h
	collision_hurt_box.position.x = animated_sprite_2d.position.x
	collision_shape_2d.position.x = animated_sprite_2d.position.x
	
	
	direction_x = Input.get_axis("ui_left", "ui_right") #平常為0，按時為-1或1
	
	if direction_x == 1 and not hurt_target:              #right
		velocity.x = move_toward(velocity.x,direction_x * Speed,acceleration)
		animated_sprite_2d.play("runLR")
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.z_index = 0
		
	elif direction_x == -1 and not hurt_target:           #left
		velocity.x = move_toward(velocity.x,direction_x * Speed,acceleration)
		animated_sprite_2d.play("runLR")
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.z_index = 1

		
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)
		
	var direction_y = Input.get_axis("ui_up", "ui_down")
	if direction_y and not hurt_target:
		velocity.y = move_toward(velocity.y,direction_y * Speed,acceleration)
		animated_sprite_2d.play("runLR")
	elif not hurt_target:
		velocity.y = move_toward(velocity.y, 0, Speed)
	if not direction_x and not direction_y and not hurt_target:
		animated_sprite_2d.play("default")
	move_and_slide()
	
		
	#戰鬥方面
	
	if rotating and attack_combo != 2:

		if not animated_sprite_2d.flip_h:
				animated_sword.position.x = animated_sprite_2d.position.x +10
		else:
				animated_sword.position.x = animated_sprite_2d.position.x -6
		animated_sword.position.y = animated_sprite_2d.position.y+4
		#collision_hurt_box.disabled = true
		animated_sword.rotation_degrees = move_toward(animated_sword.rotation_degrees, rotation_target,6)
		
		if animated_sword.animation != "attack1":
			animated_sword.play("attack1")
		if Input.is_action_just_pressed("ui_attack") :
			attack_combo += 1
			print("attack_combo + 1, attack_combo = %d"%attack_combo)
		if is_equal_approx(animated_sword.rotation_degrees, rotation_target) and attack_combo == 1:
			rotating = false
			animated_sword.play("default")
			attack_combo = 0
			
			
			animated_sword.position.y = 8
			if not animated_sprite_2d.flip_h :
				animated_sword.rotation_degrees = -170
				animated_sword.position.x = animated_sprite_2d.position.x-4
			elif animated_sprite_2d.flip_h :
				animated_sword.rotation_degrees = 170
				animated_sword.position.x = animated_sprite_2d.position.x+4
	if attack_combo == 2:
		collision_sword.disabled = true
		animated_sword.play("attack2")
		if not animated_sprite_2d.flip_h:
			animated_sword.rotation_degrees = 90
		else:
			animated_sword.rotation_degrees = -90
		collision_sword_2.disabled = false
		animated_sword.position.x = move_toward(animated_sword.position.x,position_target,1)
		if is_equal_approx(animated_sword.position.x, position_target):
			rotating = false
			animated_sword.play("default")
			attack_combo = 0
			collision_sword_2.disabled = true
			animated_sword.position.y = 8
			if not animated_sprite_2d.flip_h :
				animated_sword.rotation_degrees = -170
				animated_sword.position.x = animated_sprite_2d.position.x-4
			elif animated_sprite_2d.flip_h :
				animated_sword.rotation_degrees = 170
				animated_sword.position.x = animated_sprite_2d.position.x+4
		
	if hurt_target != 0:
		animated_sprite_2d.position.x = move_toward(animated_sprite_2d.position.x,hurt_target,0.1)
		hurt_box.monitorable = false
		if Stats.health <= 0:
			animated_sprite_2d.play("dead")
		elif is_equal_approx(animated_sprite_2d.position.x,hurt_target):
			hurt_target = 0
			animated_sprite_2d.play("default")
			print("%d life"%Stats.health)
			hurt_box.monitorable = true
		else:
			animated_sprite_2d.play("hurt")
			
func _input(_event):     #按任意鍵時執行
	#戰鬥方面
	if Input.is_action_just_pressed("ui_attack") and not rotating:
		if not animated_sprite_2d.flip_h:
			animated_sword.rotation_degrees = 46
		else:
			animated_sword.rotation_degrees = -46
		rotating = true
		var flip = animated_sword.flip_h #劍是否旋轉
		attack_flip.emit(flip) #傳給怪物
		
func _on_hurt_box_hurt(_hitbox):
	Stats.health -= 1
	if not animated_sprite_2d.flip_h:
		hurt_target = animated_sprite_2d.position.x - 5
	else:
		hurt_target = animated_sprite_2d.position.x + 5
	
	
		
		

func _on_animated_sprite_2d_animation_finished():
	if animated_sprite_2d.animation == "dead":
		camera_2d.position.x = animated_sprite_2d.position.x
		camera_2d.position.y = animated_sprite_2d.position.y
		queue_free()
		animated_sword.position.y = -11
		animated_sword.rotation_degrees = -90
