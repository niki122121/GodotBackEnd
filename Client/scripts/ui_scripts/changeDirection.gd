extends GPUParticles2D

var aV2: Vector2
var bV2: Vector2

var minAngle = INF
var maxAngle = -INF

var points = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_direction(Vector2(83,69), 90.665,306.4)
	emitting = true
	
func set_direction(topLeft: Vector2, height: float, width: float):
	points.append(topLeft)
	points.append(topLeft + Vector2(width, 0))
	points.append(topLeft + Vector2(0, height))
	points.append(topLeft + Vector2(width, height))
	
	var midV2 = Vector2(topLeft.x + width/2, topLeft.y + height/2)
	
	var origin = global_position 
	var forward = (midV2 - origin).normalized()
	
	for corner in points:
		var dir = (corner - origin).normalized()

		var angle = forward.angle_to(dir)

		if angle < minAngle:
			minAngle = angle
			aV2 = corner	   

		if angle > maxAngle:
			maxAngle = angle
			bV2 = corner

	
	var dirA = (aV2 - origin).normalized()
	var dirB = (bV2 - origin).normalized()


	var middleDir = (dirA + dirB).normalized()
	var dirV3 = Vector3(middleDir.x, middleDir.y, 0)
	var material = process_material
	material.direction = dirV3
	
	var speed = origin.distance_to(midV2) / lifetime
	material.initial_velocity_min = speed - 15
	material.initial_velocity_max = speed + 30
	
	if origin.x >= topLeft.x and origin.x <= topLeft.x + width and origin.y >= topLeft.y and origin.y <= topLeft.y + height:
			material.spread = 180
	else:
		material.spread = rad_to_deg(abs(middleDir.angle_to(dirA)))
	
