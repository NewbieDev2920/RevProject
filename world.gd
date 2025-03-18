extends Node3D

@onready var mainMenu = $CanvasLayer/MainMenu
@onready var addresEntry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/AddressEntry
const Player = preload("res://player.tscn")
const PORT = 3333
var enet_peer = ENetMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_host_button_pressed() -> void:
	mainMenu.hide()
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(addPlayer)
	
	addPlayer(multiplayer.get_unique_id())


func _on_join_button_pressed() -> void:
	mainMenu.hide()
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	addPlayer(multiplayer.get_unique_id())
	
func addPlayer(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)
