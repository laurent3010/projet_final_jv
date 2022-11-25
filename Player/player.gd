extends KinematicBody2D

export var MAX_SPEED = 80
export var ROLL_SPEED = 100
export var ACCELERATION = 500
export var FRICTION = 500
var stage=0

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
var mrd = 1
var etc=1
var etb = 0 

onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var swordhitbox = $itboxpivot/sword_hitbox
onready var hurtbox = $hurtbox
onready var hurtboxcol = $hurtbox/CollisionShape2D
onready var BTimer = $BTimer
onready var tween = $Tween
onready var light =$Light2D
onready var cooldown =$cooldown
onready var Lighttimer =$LightTimer

puppet var puppet_position = Vector2(0,0)setget puppet_position_set

puppet var puppet_velocity = Vector2(0,0)
puppet var puppet_input_vector = Vector2(0,0)
puppet var puppet_state=PlayerStats
puppet var puppet_mourir = 1

signal pizza

func _ready():
	stats.connect("no_health",self,"mourir")
	animation_tree.active = true
	swordhitbox.knockback_vector = roll_vector
	yield(get_tree(),"idle_frame")
	if is_network_master():
		Global.player_master=self

func _physics_process(delta):
	if is_network_master():
		
		match state:
			MOVE:
				move_state(delta)
			ROLL:
				roll_state(delta)
			ATTACK:
				attack_state(delta)
	else:
		match puppet_state:
			MOVE:
				move_state(delta)
			ROLL:
				roll_state(delta)
			ATTACK:
				attack_state(delta)
	if (puppet_mourir == 2):
		
		puppet_mourir()
	
func move_state(delta):
	
	if is_network_master():
		if mrd!=2:
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

			if etb ==1:
				state = ATTACK
		
		if Input.is_action_just_pressed("roll"):

			state = ROLL
		
		if Input.is_action_just_pressed("ability"):
			if etc==1:
				light.texture_scale = 1
				Lighttimer.start()
				etc =2
		
	else:
		if puppet_input_vector != Vector2.ZERO:
			roll_vector = puppet_input_vector
			swordhitbox.knockback_vector = puppet_input_vector
			animation_tree.set("parameters/idle/blend_position", puppet_input_vector)
			animation_tree.set("parameters/run/blend_position", puppet_input_vector)
			animation_tree.set("parameters/attack/blend_position", puppet_input_vector)
			animation_tree.set("parameters/roll/blend_position", puppet_input_vector)
			animation_state.travel("run")
		else:
			animation_state.travel("idle")
			if not tween.is_active():
				puppet_velocity = puppet_velocity.move_toward(puppet_input_vector * MAX_SPEED , ACCELERATION * delta )
				
			puppet_move()	
	

func roll_state(delta):
	velocity = roll_vector*ROLL_SPEED
	animation_state.travel("roll")
	move()

	
func attack_state(delta):
	velocity = Vector2.ZERO
	animation_state.travel("attack")
	
	
func move():
	velocity = move_and_slide(velocity)
	
	
func puppet_move():
	puppet_velocity = move_and_slide(puppet_velocity)	

func roll_animation_finished():
	velocity = velocity/2
	state = MOVE

func attack_animation_finish():
	state = MOVE
	
sync func set_position(pos):
	global_position=pos
	puppet_position=pos
	
func attaque_bouleDeFeu():
	
	if boule_de_feu:
		var boule = boule_de_feu.instance()
		get_tree().current_scene.add_child(boule)
		boule.global_position = self.global_position
		
		var Brotation = self.global_position.direction_to(get_global_mouse_position()).angle()
		boule.rotation = Brotation
		BTimer.start()

func _on_hurtbox_area_entered(area):
	mourir()
	#hurtbox.start_invincibility(0.5)
	#hurtbox.create_hit_effect()

func puppet_position_set(new_value):
	puppet_position=new_value

	tween.interpolate_property(self,"global_position",global_position,puppet_position,0.1)
	tween.start()



func _on_Network_tick_rate_timeout():
	if is_network_master():
		rset_unreliable("puppet_mourir",mrd)
		rset_unreliable("puppet_position",global_position)
		rset_unreliable("puppet_velocity",velocity)
		rset_unreliable("puppet_input_vector",input_vector)
		rset_unreliable("puppet_state",state)


func mourir():
	if is_network_master():
		hide()
		etb =0
		
		hurtbox.monitoring= false
		mrd=2
		
		emit_signal("pizza")
	#change_scene("res://World/game_over.tscn")
	

func puppet_mourir():
	visible = false

	hurtbox.monitoring= false


func _on_LightTimer_timeout():
	light.texture_scale=0.3
	cooldown.start()
	
sync func update_position(pos):
	global_position = pos
	puppet_position = pos

func _on_cooldown_timeout():
	etc = 1
func _onstartgame():
	etb =1
	if is_network_master():
		light.visible= true

func respaun():
	if is_network_master():
		show()
		etb =1
		light.visible= true
			
		hurtbox.monitoring= true
		mrd=0
