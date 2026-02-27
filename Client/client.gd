extends Node

signal connected      # Connected to server
signal receivedData   # Received data from server
signal disconnected   # Disconnected from server
signal error          # Error with connection to server

var _status: int = 0
var _stream: StreamPeerTCP = StreamPeerTCP.new()
var _secureStream: StreamPeerTLS = StreamPeerTLS.new()
var _trusted_certificate: X509Certificate = X509Certificate.new()
var _tls_options: TLSOptions
func _ready() -> void:
	_trusted_certificate.load("C:/Users/Gonza/Desktop/Curro/SSH/realmweaver.etsii.urjc.es.pem")
	_tls_options = TLSOptions.client(_trusted_certificate)

func _process(_delta: float) -> void:
	var new_status: int = _secureStream.get_status()
	if new_status != _status:
		_status = new_status
		print("New status: ", _status)
		match _status:
			_secureStream.STATUS_DISCONNECTED:
				print("Disconnected from host.")
				disconnected.emit()
			_secureStream.STATUS_CONNECTED:
				print("Connected to host.")
				connected.emit()	
			_secureStream.STATUS_ERROR:
				print("Error with socket stream.")
				error.emit()
			_secureStream.STATUS_ERROR_HOSTNAME_MISMATCH:
				print("Error Hostname Mismatch.")
				error.emit()
	
	if _status == _secureStream.STATUS_CONNECTED:
		var available_bytes: int = _stream.get_available_bytes()
		if available_bytes > 0:
			print("available bytes: ", available_bytes)
			var data: Array = _secureStream.get_partial_data(available_bytes)
			# Check for read error.
			if data[0] != OK:
				print("Error getting data from stream: ", data[0])
				error.emit()
			else:
				receivedData.emit(data[1])


func connect_to_host(host: String, port: int) -> void:
	print("Connecting to %s:%d" % [host, port])
	# Reset status so we can tell if it changes to error again.
	_status = _secureStream.STATUS_DISCONNECTED
	_stream.connect_to_host(host, port)
	_stream.poll()
	while _stream.get_status() != 2: #and cycles/timer (to prevent softlock)
		_stream.poll()
	print("connecting via TLS")
	if _secureStream.connect_to_stream(_stream, "realmweaver.etsii.urjc.es", _tls_options) != OK:
	#if _stream.connect_to_host(host, port) != OK:
		print("Error connecting to host")
		error.emit()
	else:
		var test = 0
		_secureStream.poll()
		while _secureStream.get_status() != 2 and test < 100000:
			_secureStream.poll()
			#test += 1
			#if test % 100 == 0:
				#print("Cycle ", test, "; status = ", _secureStream.get_status())
		if _secureStream.get_status() == 2:
			connected.emit()
		else:
			print("ERROR: Can not connect to server, reason unknown.")
			error.emit();
			
func disconnect_from_host() -> void:
	print("Ending connection.")
	_secureStream.disconnect_from_stream()
	_stream.disconnect_from_host()
	disconnected.emit()

func send(data: PackedByteArray) -> bool:
	if _status != _secureStream.STATUS_CONNECTED:
		print("Error: Stream is not currently connected.")
		return false
	var message: int = _secureStream.put_data(data)
	if message != OK:
		print("Error writing to stream: ", message)
		return false
	print("Message sent sucesfully")
	return true
