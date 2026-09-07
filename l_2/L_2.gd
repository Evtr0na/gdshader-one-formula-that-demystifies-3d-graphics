extends ColorRect

# -----------------------------------------------------------------
# -- base_state
# -----------------------------------------------------------------
@export var focal_length: float = 500.0
@export var radius = 0.0
@export var smooth_values := 0.005
@export var line_width: float = 5.0
@onready var material_ := self.material as ShaderMaterial
var point: PackedVector2Array = [Vector2(0.0, 0.0), Vector2(100.0, 100.0)]

# -----------------------------------------------------------------
# -- custom_state
# -----------------------------------------------------------------

var rotation_value: float = 0.0
var speed_rotation: float = 100.0


func _physics_process(_delta: float) -> void:
	var result_: Dictionary = frame(point, _delta)
	var points: PackedVector2Array = result_["array_"]

	material_.set_shader_parameter("points", points)
	material_.set_shader_parameter("point_count", points.size())
	material_.set_shader_parameter("game_width", size.x)
	material_.set_shader_parameter("game_higth", size.y)
	material_.set_shader_parameter("radius", radius)
	material_.set_shader_parameter("smooth_values", smooth_values)
	material_.set_shader_parameter("line_width", line_width)


func frame(p: PackedVector2Array, delta: float) -> Dictionary:
	var array_: PackedVector2Array = []
	rotation_value += speed_rotation * delta
	for i in range(p.size()):
		var b := R_2d(p[i], rotation_value)
		var a := screen(b)
		array_.append(a)
	return { "array_": array_ }


func R_2d(p: Vector2, a: float) -> Vector2:

	var a_ = deg_to_rad(a)

	return matrix(
	 [Vector4(cos(a_),-sin(a_),0.0,0.0),
	  Vector4(sin(a_),cos(a_),0.0,0.0)],

	 {"1":Vector4(p.x,p.y,0.0,0.0)},

	 2)["1"]	 


func matrix(m: Array, a: Dictionary, f: int) -> Dictionary:
	#a = {"1" = vector4(1.0,1.0,1.0,1.0)}
	# [
	# vector4(1.0,1.0,1.0,1.0),
	# vector4(1.0,1.0,1.0,1.0),
	# vector4(1.0,1.0,1.0,1.0),
	# vector4(1.0,1.0,1.0,1.0)
	# ]
	var result := { }

	for key in a:
		var v: Vector4 = a[key]

		match f:
			2:
				result[key] = Vector2(m[0].dot(v), m[1].dot(v))

			3:
				result[key] = Vector3(m[0].dot(v), m[1].dot(v), m[2].dot(v))

			4:
				result[key] = Vector4(m[0].dot(v), m[1].dot(v), m[2].dot(v), m[3].dot(v))


	return result

func screen(p: Vector2) -> Vector2:
	return Vector2(p.x + 0.5 * size.x, (-p.y + 0.5 * size.y))
