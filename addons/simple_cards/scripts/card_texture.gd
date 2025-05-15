##Used in the card node for manging some effects.
class_name CardTexture
extends TextureRect


var angle_x_max: float = .2
var angle_y_max: float = .2


const PERSPECTIVE_SHADER: Shader = preload("res://addons/simple_cards/assets/perspective_shader.gdshader")
var shader: Shader = null

func _ready():
	gui_input.connect(_on_gui_input)
	if !material:
		material = ShaderMaterial.new()
		material.shader = PERSPECTIVE_SHADER


func reset_shader_rot():
	material.set_shader_parameter("x_rot", 0)
	material.set_shader_parameter("y_rot", 0)
	
func _on_gui_input(event: InputEvent):
		
	
	if not event is InputEventMouseMotion: return
	
	var mouse_pos: Vector2 = get_local_mouse_position()
	
	var lerp_val_x: float = remap(mouse_pos.x, 0.0, size.x, 0, 1)
	var lerp_val_y: float = remap(mouse_pos.y, 0.0, size.y, 0, 1)
	
	var rot_x: float = rad_to_deg(lerp_angle(-angle_x_max, angle_x_max, lerp_val_x))
	var rot_y: float = rad_to_deg(lerp_angle(angle_y_max, -angle_y_max, lerp_val_y))
	
	material.set_shader_parameter("x_rot", rot_y)
	material.set_shader_parameter("y_rot", rot_x)

func flip_card(_to: CompressedTexture2D, _duration: float):
	_tween_rotation(0, 90, _duration/2)
	await get_tree().create_timer(_duration/2).timeout
	texture = _to
	_tween_rotation(-90, 0, _duration/2)
	await get_tree().create_timer(_duration/2).timeout

func _tween_rotation(_from: float = 0.0, _to: float = 0.0, _duration: float = 0.2):
	var rot_tween: Tween
	if rot_tween:
		rot_tween.kill()
		
	rot_tween = create_tween().set_ease(Tween.EASE_OUT)
	rot_tween.tween_property(self, "material:shader_parameter/y_rot", _to, _duration).from(_from)
	
