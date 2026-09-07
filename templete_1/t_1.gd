extends ColorRect

# -----------------------------------------------------------------
# -- base_state
# -----------------------------------------------------------------
@export var focal_length:float = 500.0
@export var radius = 0.0
@export var smooth_values := 0.005
@export var line_width:float =  5.0
@onready var material_ := self.material as ShaderMaterial
var point:PackedVector2Array = [


]


func _physics_process(_delta: float) -> void:

	var result_:Dictionary = frame(point)
	var points:PackedVector2Array = result_["array_"]

	material_.set_shader_parameter("points",points)
	material_.set_shader_parameter("point_count",points.size())
	material_.set_shader_parameter("game_width",size.x)
	material_.set_shader_parameter("game_higth",size.y)
	material_.set_shader_parameter("radius",radius)
	material_.set_shader_parameter("smooth_values",smooth_values)
	material_.set_shader_parameter("line_width",line_width)

func frame(p)->Dictionary:
	p = p	
	return {"array_":p}
