extends Enemy

@onready var left_cheaker = $Graphics/Left_cheaker
@onready var right_cheaker = $Graphics/Right_cheaker
@onready var animated_sprite_2d = $Graphics/AnimatedSprite2D
@onready var hurt_box = $Graphics/HurtBox
@onready var Stats = $stats
 
var flip_back = false
var attack_from_left = false #辨識攻擊方向
var position_target = 0

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.attack_flip.connect(_on_player_attack)
	

func _process(delta):
	if animated_sprite_2d.animation != "hurt":
		animated_sprite_2d.play("move")
		if right_cheaker.is_colliding():
			direction = Direction.LEFT
			animated_sprite_2d.flip_h = true
		if left_cheaker.is_colliding():
			direction = Direction.RIGHT
			animated_sprite_2d.flip_h = false
		position.x += direction * max_speed * delta
	if attack_from_left:
		position_target = animated_sprite_2d.position.x + 7
	else:
		position_target = animated_sprite_2d.position.x - 7
	

func _on_hurt_box_hurt(_hitbox):
	Stats.health -= 1
	if attack_from_left:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("hurt")
	velocity.x = move_toward(velocity.x, position_target, 0.5)
	if Stats.health == 0:
		queue_free()
	

func _on_player_attack(flip): #偵測玩家是否按攻擊與其方向
	if animated_sprite_2d.flip_h != flip:
		flip_back = false
		print("not need")
	else:
		flip_back = true
		print("be attacked, need to flip")
	if flip:
		attack_from_left = false
	else:
		attack_from_left = true


func _on_animated_sprite_2d_frame_changed(): #受擊完畢
	if animated_sprite_2d.animation == "hurt" and animated_sprite_2d.frame == animated_sprite_2d.sprite_frames.get_frame_count(animated_sprite_2d.animation) - 1:
		animated_sprite_2d.play("default")
		if flip_back:
			animated_sprite_2d.flip_h = not animated_sprite_2d.flip_h
			flip_back = false
			
		print("end")
