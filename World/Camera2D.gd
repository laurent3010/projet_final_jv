extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var target_player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	target_player = Global.player_master


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if  Global.player_master !=null:
		global_position = Global.player_master.global_position
