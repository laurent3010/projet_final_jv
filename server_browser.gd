extends Control


onready var server_listener = $srever_listener
onready var server_ip_text_edit = $TextureRect/Panel/server_ip_adress
onready var server_container = $TextureRect/Panel/VBoxContainer
onready var manual_setup_button = $TextureRect/Panel/manual_setup


# Called when the node enters the scene tree for the first time.




# Called every frame. 'delta' is the elapsed time since the previous frame.




func _on_srever_listener_new_server(serverInfo):
	var server_node = Global.instance_node(load("res://Server_display.tscn"), server_container)
	server_node.text = "%s - %s" % [serverInfo.ip, serverInfo.name]
	server_node.ip_address = str(serverInfo.ip)

func _on_Server_listener_remove_server(serverIp):
	for serverNode in server_container.get_children():
		if serverNode.is_in_group("Server_display"):
			if serverNode.ip_address == serverIp:
				serverNode.queue_free()
				break
	 # Replace with function body.



func _on_go_back_pressed():
	get_tree().reload_current_scene()



func _on_manual_setup_pressed():
	if manual_setup_button.text != "retour a la recherche":
		server_ip_text_edit.show()
		manual_setup_button.text = "retour a la recherche"
		server_container.hide()
		server_ip_text_edit.call_deferred("grab_focus")
	else:
		server_ip_text_edit.text = ""
		server_ip_text_edit.hide()
		manual_setup_button.text = "manual setup"
		server_container.show()


func _on_join_server_button_pressed():
	Music.playable= 2
	Network.ip_address = server_ip_text_edit.text
	hide()
	Network.join_server()
