extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal ragnarock

# Called when the node enters the scene tree for the first time.
func _ready():
	Persistent_nodes.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
var player_instance = Global.player_master


func _on_return_menu_pressed():
	Persistent_nodes.show()

	Music.playable =1
	get_tree().change_scene("res://Network_setup.tscn")
	Network._server_disconnected()
	Global.player_master = null

func _on_ressayer_pressed():
	
	Persistent_nodes.show()
	for player in Persistent_nodes.get_children():
		if player.is_in_group("Player"):
			player.respaun()
			
	
	get_tree().change_scene("res://World/Real_game.tscn")
	

func _on_quit_pressed():
	for player in Persistent_nodes.get_children():
		if player.is_in_group("Player"):
			Network._server_disconnected()
			Global.player_master = null
	get_tree().quit()
