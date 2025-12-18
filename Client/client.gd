extends Node

signal connected      # Connected to server
signal receivedData   # Received data from server
signal disconnected   # Disconnected from server
signal error          # Error with connection to server

var _status: int = 0
var _stream: StreamPeerTCP = StreamPeerTCP.new()

func _ready() -> void:
	#_status = _stream.get_status()
	#print(_status)
	pass

func _process(_delta: float) -> void:
	var new_status: int = _stream.get_status()
	if new_status != _status:
		_status = new_status
		print("New status: ", _status)
		match _status:
			_stream.STATUS_NONE:
				print("Disconnected from host.")
				disconnected.emit()
			_stream.STATUS_CONNECTING:
				print("Connecting to host.")
			_stream.STATUS_CONNECTED:
				print("Connected to host.")
				connected.emit()	
			_stream.STATUS_ERROR:
				print("Error with socket stream.")
				error.emit()
	
	if _status == _stream.STATUS_CONNECTED:
		var available_bytes: int = _stream.get_available_bytes()
		if available_bytes > 0:
			#print("available bytes: ", available_bytes)
			var data: Array = _stream.get_partial_data(available_bytes)
			# Check for read error.
			if data[0] != OK:
				print("Error getting data from stream: ", data[0])
				error.emit()
			else:
				receivedData.emit(data[1])


func connect_to_host(host: String, port: int) -> void:
	print("Connecting to %s:%d" % [host, port])
	# Reset status so we can tell if it changes to error again.
	_status = _stream.STATUS_NONE
	if _stream.connect_to_host(host, port) != OK:
		print("Error connecting to host.")
		error.emit()
	else:
		_stream.poll()
		#print("Connected to ", _stream.get_connected_host(), ":", _stream.get_connected_port(), " with status ", _stream.get_status())
		if _stream.get_status() == 2:
			connected.emit()
			
func disconnect_from_host() -> void:
	print("Ending connection.")
	_stream.disconnect_from_host()
	disconnected.emit()

func send(data: PackedByteArray) -> bool:
	if _status != _stream.STATUS_CONNECTED:
		print("Error: Stream is not currently connected.")
		return false
	var message: int = _stream.put_data(data)
	if message != OK:
		print("Error writing to stream: ", message)
		return false
	print("Message sent sucesfully")
	return true
