extends Node


const default_port= 28960
const maxclient = 2

var server = null
var client = null

var ip_address = ""


# Called when the node enters the scene tree for the first time.
func _ready() ->void:
	if OS.get_name() == "Windows":
		ip_address = IP.get_local_addresses()[3]
	elif OS.get_name() == "Android":
		ip_address = IP.get_local_addresses()[0]
	else:
		ip_address = IP.get_local_addresses()[3]
	
	for ip in IP.get_local_addresses():
		if ip.begins_with("192.168.") and not ip.ends_with(".1"):
			ip_address = ip
			
	get_tree().connect("connected_to_server",self,"_connected_to_server")
	get_tree().connect("server_disconnected",self,"_server_disconnected")

func create_server() ->void:
	server=NetworkedMultiplayerENet.new()
	server.create_server(default_port,maxclient)
	get_tree().set_network_peer(server)
	
func join_server() -> void:
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_address, default_port)
	get_tree().set_network_peer(client)


func _connected_to_server() -> void:
	
	print("sa c'est bien connecter")
	
func _server_disconnected()->void:
	print("sa c'est bien Déconnecter")

