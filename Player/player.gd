extends KinematicBody2D

export var MAX_SPEED = 80
export var ROLL_SPEED = 100
export var ACCELERATION = 500
export var FRICTION = 500

export (PackedScene) var boule_de_feu: PackedScene= preload("res://hitbox_and_hurtbox/boule de feu.tscn")

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var swordhitbox = $itboxpivot/sword_hitbox
onready var hurtbox = $hurtbox
onready var BTimer = $BTimer
onready var tween = $Tween


puppet var puppet_velocity = Vector2(0,0)setget puppet_position_set
puppet var puppet_input_vector = Vector2(0,0)


func _ready():
	stats.connect("no_health",self,"queue_free")
	animation_tree.active = true
	swordhitbox.knockback_vector = roll_vector

func _physics_process(delta):
	if is_network_master():
		match state:
			MOVE:
				move_state(delta)
			ROLL:
				roll_state(delta)
			ATTACK:
				attack_state(delta)
				
		
	
func move_state(delta):
	
	if is_network_master():
		
		input_vector.x = Input. get_action_strength("ui_right") - Input. get_action_strength("ui_left")
		input_vector.y = Input. get_action_strength("ui_down") - Input. get_action_strength("ui_up") 
		input_vector = input_vector.normalized()
		
		if input_vector != Vector2.ZERO:
			roll_vector = input_vector
			swordhitbox.knockback_vector = input_vector
			animation_tree.set("parameters/idle/blend_position", input_vector)
			animation_tree.set("parameters/run/blend_position", input_vector)
			animation_tree.set("parameters/attack/blend_position", input_vector)
			animation_tree.set("parameters/roll/blend_position", input_vector)
			animation_state.travel("run")
			velocity = velocity.move_toward(input_vector * MAX_SPEED , ACCELERATION * delta )
		else:
			animation_state.travel("idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			
		move()	
			
		if Input.is_action_just_pressed("attack"):
			state = ATTACK
		if Input.is_action_just_pressed("roll"):
			state = ROLL
	else:
		
		if not tween.is_active():
			puppet_velocity = puppet_velocity.move_toward(puppet_input_vector * MAX_SPEED , ACCELERATION * delta )
			
	

func roll_state(delta):
	velocity = roll_vector*ROLL_SPEED
	animation_state.travel("roll")
	move()
	
func attack_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("attack")
	
func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	velocity = velocity/2
	state = MOVE

func attack_animation_finish():
	state = MOVE
	

func attaque_bouleDeFeu():
	
	if boule_de_feu:
		var boule = boule_de_feu.instance()
		get_tree().current_scene.add_child(boule)
		boule.global_position = self.global_position
		
		var Brotation = self.global_position.direction_to(get_global_mouse_position()).angle()
		boule.rotation = Brotation
		BTimer.start()

func _on_hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()

func puppet_position_set(new_value):
	puppet_velocity=new_value

	tween.interpolate_property(self,"velocity",velocity,puppet_velocity,0.1)
	tween.start()

func _on_Network_tick_rate_timeout():
	if is_network_master():
		
		rset_unreliable("puppet_velocity",velocity)
		rset_unreliable("puppet_input_vector",input_vector)
