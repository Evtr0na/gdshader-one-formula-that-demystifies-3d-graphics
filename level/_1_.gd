extends Sprite2D

@export var p_1:float = 1.0
@export var p_2:float = 1.0
@export var p_3:float = 1.0
@export var p_4:float = 1.0

var material_ := self.material as ShaderMaterial


func _physics_process(_delta: float) -> void:
	var points:PackedVector2Array = [
		screen(project(Vector3(1.0,1.0,1.0))),
		Vector2(0.5,0.5)
		# screen(project(Vector3(-0.5,-0.5,1.0))),

		]
	print(screen(project(Vector3(1.0,1.0,1.0))))
	# print(screen(project(Vector3(1.0,1.0,1.0)))==Vector2(0.5,0.5))
	material_.set_shader_parameter("points",points)
	material_.set_shader_parameter("point_count",points.size())


func project(point:Vector3)->Vector2:
	var x_ = point.x/point.z
	var y_ = point.y/point.z
	return Vector2(x_,y_)

func screen(p:Vector2)->Vector2:
	var x_ = p.x-0.5
	var y_ = -( p.y-0.5 )
	# var x_ = p.x/2.0+0.5
	# var y_ =1- (p.y/2.0+0.5 )
	# print(Vector2( x_,y_) )
	return Vector2(x_,y_)
