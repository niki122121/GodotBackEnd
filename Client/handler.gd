extends Node

const HOST: String = "127.0.0.1"
const PORT: int = 6664
const RECONNECT_TIMEOUT: float = 3.0

const Client = preload("res://client.gd")
var _client: Client = Client.new()

func _ready() -> void:
	_client.connected.connect(_handle_client_connected)
	_client.disconnected.connect(_handle_client_disconnected)
	_client.error.connect(_handle_client_error)
	_client.receivedData.connect(_handle_server_data)
	add_child(_client)
	_client.connect_to_host(HOST, PORT)

func _connect_after_timeout(timeout: float) -> void:
	await get_tree().create_timer(timeout).timeout # Delay for timeout
	print("Trying to reconnect...")
	_client.connect_to_host(HOST, PORT)

func _handle_client_connected() -> void:
	print("Client connected to server")

func _handle_client_data(data: PackedByteArray) -> void:
	print("Client data: ", data.get_string_from_utf8())
	_client.send(data)
	
func _handle_server_data(data: PackedByteArray) -> void:
	print("Server data: ", data.get_string_from_utf8())

func _handle_client_disconnected() -> void:
	print("Client disconnected from server.")
	#_connect_after_timeout(RECONNECT_TIMEOUT) # Try to reconnect after 3 seconds

func _handle_client_error() -> void:
	print("Client error.")
	_connect_after_timeout(RECONNECT_TIMEOUT) # Try to reconnect after 3 seconds

func _on_send_message_button_pressed() -> void:
	var bytes: PackedByteArray = [104, 101, 108, 108, 111] # Bytes for "hello" in ASCII
	_handle_client_data(bytes)

func _on_connect_button_pressed() -> void:
	_client.connect_to_host(HOST, PORT)

func _on_disconnect_button_pressed() -> void:
	_client.disconnect_from_host()
