class_name HitBox
extends Area2D

signal hit(hurtbox)


func _init():
	area_entered.connect(on_area_entered)
	
func on_area_entered(hurtbox:HurtBox):
	print("[Hit] %s -> %s" %[owner.name,hurtbox.owner.name] )
	hit.emit(hurtbox)
	hurtbox.hurt.emit(self)
