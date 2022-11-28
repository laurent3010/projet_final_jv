extends Node2D


# Declare member variables here. Examples:
var a = 1
onready var world =$world
onready var darkness =$CanvasModulate
var player_instance = Global.player_master

var current_spawn_location_instance_number = 1
var current_player_for_spawn_location_number = null
# Called when the node enters the scene tree for the first time.

func _ready():	
	
	if get_tree().is_network_server():
		if player_instance.is_in_group("Player"):
			for spawn_location in $Spawn_locations.get_children():
				if int(spawn_location.name) == current_spawn_location_instance_number and current_player_for_spawn_location_number != player_instance:
					player_instance.rpc("update_position", spawn_location.global_position)
					player_instance.rpc("enable")
					current_spawn_location_instance_number += 1
					




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_instance !=null:
		player_instance.connect("pizza",self,"game_over")
		
	if Input.is_action_just_pressed("debug_mod"):
		if a ==1:
			darkness.hide()
			a=2
		else:
			darkness.show()
			a=1

func game_over():
	#world.queue_free()
	darkness.visible
	get_tree().change_scene("res://World/game_over.tscn")
