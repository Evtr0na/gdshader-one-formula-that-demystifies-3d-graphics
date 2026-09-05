extends Sprite2D
@export var game_width:float = 1.0
@export var game_higth:float = 1.0
var int_width :float
var int_higth :float
@export var offest:float = 1.0
@export var radius = 0.0
# @export var p_1:float = 1.0
# @export var p_2:float = 1.0
# @export var p_3:float = 1.0
# @export var p_4:float = 1.0

var material_ := self.material as ShaderMaterial


func _physics_process(_delta: float) -> void:
	offest_()
	var points:PackedVector2Array = [
		screen(project(Vector3(0.5,-0.5,2.0))),
		screen(project(Vector3(0.5,-0.5,3.0))),
		screen(project(Vector3(0.5,0.5,2.0))),
		screen(project(Vector3(0.5,0.5,3.0))),
		screen(project(Vector3(-0.5,-0.5,2.0))),
		screen(project(Vector3(-0.5,-0.5,3.0))),
		screen(project(Vector3(-0.5,0.5,2.0))),
		screen(project(Vector3(-0.5,0.5,3.0))),
		# screen(project(Vector3(0.0,0.0,1.0))),

		]
	material_.set_shader_parameter("points",points)
	material_.set_shader_parameter("point_count",points.size())
	material_.set_shader_parameter("game_width",int_width)
	material_.set_shader_parameter("game_higth",int_higth)
	material_.set_shader_parameter("radius",radius)

func offest_()->void:
	int_width = game_width*offest
	int_higth = game_higth*offest
	


func project(point:Vector3)->Vector2:
	var x_ = point.x/point.z
	var y_ = point.y/point.z
	return Vector2(x_,y_)

func screen(p:Vector2)->Vector2:
	var x_ = p.x+0.5*int_width
	var y_ = -p.y+0.5*int_higth
	# var x_ = p.x/2.0+0.5
	# var y_ =1- (p.y/2.0+0.5 )
	# print(Vector2( x_,y_) )
	return Vector2(x_,y_)
