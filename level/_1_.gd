extends ColorRect
@export var focal_length:float = 500.0
@export var game_width:float = 1.0
@export var game_higth:float = 1.0
@export var offest:float = 1.0
@export var radius = 0.0
@export var smooth_values := 0.005
@export var line_width:float =  5.0

@export var distance_:float = 1.0
var time_:float = 0.0

@onready var material_ := self.material as ShaderMaterial
@export var rotation_:Vector3 = Vector3(0.0,0.0,0.0)
var cum_movement:float = 0.0

var center_ := Vector3(0.0,0.0,600)

var point:PackedVector3Array = [

	# Vector3(+0.0,+0.0,+1.0),
	Vector3(+200.0,+200.0,+400.0),
	Vector3(-200.0,+200.0,+400.0),
	Vector3(-200.0,-200.0,+400.0),
	Vector3(+200.0,-200.0,+400.0),
	

	Vector3(+200.0,+200.0,+800.0),
	Vector3(-200.0,+200.0,+800.0),
	Vector3(-200.0,-200.0,+800.0),
	Vector3(+200.0,-200.0,+800.0),

]


func _physics_process(_delta: float) -> void:
	time(_delta)

	var result_:Dictionary = frame(point,_delta,distance_,rotation_)
	var points:PackedVector2Array = result_["array_"]

	material_.set_shader_parameter("points",points)
	material_.set_shader_parameter("point_count",points.size())
	material_.set_shader_parameter("game_width",size.x)
	material_.set_shader_parameter("game_higth",size.y)
	material_.set_shader_parameter("radius",radius)
	material_.set_shader_parameter("smooth_values",smooth_values)
	material_.set_shader_parameter("line_width",line_width)

# 批处理
func frame(p_:PackedVector3Array,delta:float,dist:float,_rotation_:Vector3)->Dictionary:
	var array_:PackedVector2Array = [] 
	rotation_.y+= 0.3*delta
	rotation_.x+= 0.3*delta
	cum_movement+=dist*delta

	for i in range(p_.size()):

		var a := rotate( center_, p_[i] , _rotation_ )
		var b := move_away(a)
		var c := project(b)
		var d := screen(c)
		array_.append(d)

	return { "array_": array_}
	
#project to screen
func project(p_:Vector3)->Vector2:
	var x_ = p_.x/p_.z*focal_length
	var y_ = p_.y/p_.z*focal_length
	return Vector2(x_,y_)

#switsch coordinate systems
func screen(p:Vector2)->Vector2:
	var x_ = p.x+0.5*size.x
	var y_ = -p.y+0.5*size.y
	return Vector2(x_,y_)



func move_away(p_: Vector3) -> Vector3:
	return Vector3(p_.x, p_.y, p_.z + cum_movement)

#Euler rotation
func rotate(center:Vector3,p_:Vector3,_rotation_: Vector3) -> Vector3:

	var cx := cos(_rotation_.x)
	var sx := sin(_rotation_.x)

	var cy := cos(_rotation_.y)
	var sy := sin(_rotation_.y)

	var cz := cos(_rotation_.z)
	var sz := sin(_rotation_.z)

	var v_ := p_

	# 1. 转换成以模型中心为原点
	v_ -= center

	# 2. 纯三角函数旋转
	# ---------- Z ----------
	var x1 := v_.x * cz - v_.y * sz
	var y1 := v_.x * sz + v_.y * cz
	var z1 := v_.z

	# ---------- X ----------
	var x2 := x1
	var y2 := y1 * cx - z1 * sx
	var z2 := y1 * sx + z1 * cx

	# ---------- Y ----------
	var x3 := x2 * cy + z2 * sy
	var y3 := y2
	var z3 := -x2 * sy + z2 * cy

	v_ = Vector3(x3, y3, z3)

	# 3. 回到模型中心
	v_ += center

	return v_

#计时器
func time(delta)->void:
	time_ += delta
	if time_ >= 3.0:
		distance_  = -distance_
		time_ = 0.0
