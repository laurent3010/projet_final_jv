extends Control

var player = load("res://Player/player.tscn")
var world = preload("res://World/world.tscn"). instance ()




onready var multiplayer_config_ui = $Multiplayer_configure
onready var username = $Multiplayer_configure/username
onready var backG = $TextureRect
onready var device_ip_address = $Multiplayer_configure/CanvasLayer/adresse_ip_device
onready var start_game = $Multiplayer_configure/CanvasLayer/start_game

var player_instance=null

# Called when the node enters the scene tree for the first time.
func _ready():


	get_tree().connect("network_peer_connected", self, "_player_connected")

	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	device_ip_address.text = Network.ip_address
	
	if get_tree().network_peer != null:
		pass
	else:
		start_game.hide()

func _process(delta):
	if get_tree().network_peer != null:
		if get_tree().get_network_connected_peers().size() >= 1 and get_tree().is_network_server():
			start_game.show()
		else:
			start_game.hide()
	if player_instance !=null:
		player_instance.connect("pizza",self,"game_over")

func _player_connected(id) -> void:
	print("Player " + str(id) + " has connected")
	
	instance_player(id)

func _player_disconnected(id) -> void:
	print("Player " + str(id) + " has disconnected")
	if Persistent_nodes.has_node(str(id)):
		Persistent_nodes.get_node(str(id)).queue_free()


func _on_creat_server_pressed():
	if username.text != "":
		Network.current_player_username = username.text
		multiplayer_config_ui.hide()
		Network.create_server()
		backG.queue_free()
		username.queue_free()
		world.visible=true
		Music.playable= 2
		instance_player(get_tree().get_network_unique_id())
	

func _on_join_server_pressed():
	if username.text != "":
		multiplayer_config_ui.hide()
		Network.current_player_username=username.text
		backG.queue_free()
		Global.instance_node(load("res://server_browser.tscn"),self)
	

func _connected_to_server() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	instance_player(get_tree().get_network_unique_id())

func instance_player(id) -> void:
	get_tree (). get_root (). add_child (world)
	player_instance  = Global.instance_node_at_location(player,Persistent_nodes,Vector2(rand_range(0,920),rand_range(0,580)))
	player_instance.name = str(id)
	player_instance.set_network_master(id)


func _on_go_back_pressed():
	get_tree().change_scene("res://option_sceane.tscn")



func _on_start_game_pressed():
	
	rpc("switch_to_game")
	
	
sync func switch_to_game() -> void:
	world.queue_free()
	for child in Persistent_nodes.get_children():
		if child.is_in_group("Player"):
			child._onstartgame()
			
	get_tree().change_scene("res://World/Real_game.tscn")
	
