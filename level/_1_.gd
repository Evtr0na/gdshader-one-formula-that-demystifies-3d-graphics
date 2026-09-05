extends ColorRect
@export var game_width:float = 1.0
@export var game_higth:float = 1.0
var int_width :float
var int_higth :float
@export var offest:float = 1.0
@export var radius = 0.0
@export var smooth_values := 0.005

var material_ := self.material as ShaderMaterial


func _physics_process(_delta: float) -> void:
	offest_()
	var points:PackedVector2Array = [
		screen(project(Vector3(0.0,0.0,1.0))),
		# screen(project(Vector3(1000,500,1.0))),
		screen(project(Vector3(0.5,-0.5,2.0))),
		screen(project(Vector3(0.5,-0.5,3.0))),
		screen(project(Vector3(0.5,0.5,2.0))),
		screen(project(Vector3(0.5,0.5,3.0))),
		screen(project(Vector3(-0.5,-0.5,2.0))),
		screen(project(Vector3(-0.5,-0.5,3.0))),
		screen(project(Vector3(-0.5,0.5,2.0))),
		screen(project(Vector3(-0.5,0.5,3.0))),
		]
	material_.set_shader_parameter("points",points)
	material_.set_shader_parameter("point_count",points.size())
	material_.set_shader_parameter("game_width",int_width)
	material_.set_shader_parameter("game_higth",int_higth)
	material_.set_shader_parameter("radius",radius)
	material_.set_shader_parameter("smooth_values",smooth_values)

func offest_()->void:
	int_width = size.x*offest
	int_higth = size.y*offest
	


func project(point:Vector3)->Vector2:
	var x_ = point.x/point.z
	var y_ = point.y/point.z
	return Vector2(x_,y_)

func screen(p:Vector2)->Vector2:
	var x_ = (p.x+0.5)
	var y_ = (-p.y+0.5)
	return Vector2(x_,y_)

func frame()->void
	
	pass
