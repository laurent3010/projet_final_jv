extends Control

var player = load("res://Player/player.tscn")
# Declare member variables here. Examples:
# var a = 2
onready var multiplayer_config_ui = $Multiplayer_configure
onready var server_text_edit = $Multiplayer_configure/server_ip_adresse
onready var backG = $Sprite
onready var device_ip_address = $Multiplayer_configure/CanvasLayer/adresse_ip_device
onready var prop_device_ip_address = $Multiplayer_configure/server_ip_adresse

# Called when the node enters the scene tree for the first time.
func _ready():
	
	get_tree().connect("network_peer_connected", self, "_player_connected")

	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

	get_tree().connect("connected_to_server", self, "_connected_to_server")
	
	device_ip_address.text = Network.ip_address
	prop_device_ip_address.text= Network.ip_address

func _player_connected(id) -> void:
	print("Player " + str(id) + " has connected")
	
	instance_player(id)

func _player_disconnected(id) -> void:
	print("Player " + str(id) + " has disconnected")
	
	if Players.has_node(str(id)):
		Players.get_node(str(id)).queue_free()


func _on_creat_server_pressed():
	multiplayer_config_ui.hide()
	Network.create_server()
	backG.queue_free()
	server_text_edit.queue_free()
	instance_player(get_tree().get_network_unique_id())

func _on_join_server_pressed():
	if server_text_edit.text != "":
		multiplayer_config_ui.hide()
		Network.ip_address=server_text_edit.text
		Network.join_server()
		backG.queue_free()
		server_text_edit.queue_free()

func _connected_to_server() -> void:
	yield(get_tree().create_timer(0.1), "timeout")
	instance_player(get_tree().get_network_unique_id())

func instance_player(id) -> void:
	var player_instance  = Global.instance_node_at_location(player,Players,Vector2(rand_range(0,920),rand_range(0,580)))
	player_instance.name = str(id)
	player_instance.set_network_master(id)
