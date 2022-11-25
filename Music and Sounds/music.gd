extends Node2D


# Declare member variables here. Examples:

onready var b = $music
var playable = 1

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playable == 2:
		if Input.is_action_just_pressed("Play_music"):
			
			if b.playing== true:
				b.playing=false
				
			else :
				b.playing=true
