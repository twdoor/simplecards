##Simple card resoruce.
@icon("res://addons/simple_cards/assets/icon_card_control.png")
class_name Card 
extends Button

const GLINT_SHADER: Shader = preload("res://addons/simple_cards/assets/highlight_shader.gdshader")

var current_texture: CompressedTexture2D = null: ##This is the texture you see
	set(v):
		current_texture = v
		set_tooltip()
var face_texture: CompressedTexture2D = null ##This is the texture of the front of the card
var back_texture: CompressedTexture2D = null ##This is the texture of the bakc of the card
var card_texture: CardTexture = null  ##This is the actual node on witch the textures are placed


var card_size: Vector2

@export var card_resource: CardResource = null ##Card Resource is where the informantion of the card is stored
@export var is_draggable: bool = true ##Sets if card can be dragged or not
var dragging: bool = false
var dragging_offset: Vector2 = Vector2.ZERO 

var use_shadow: bool = true
var shadow_card: TextureRect = null
var play_key: String = ""

@export_enum("Back", "Face") var start_face = "Back"
#Tween Animating
var hover_tween: Tween
@export var flip_duration: float = 0.3

#glint
@export var show_glint: bool = false:
	set(v):
		show_glint = v
		if show_glint:
			(material as ShaderMaterial).shader = GLINT_SHADER
		else:
			(material as ShaderMaterial).shader = null

func _ready():
	set_required()
	set_globals()


func _process(delta):
	on_dragged()
	handle_shadow()


func _unhandled_input(event):
	if event.is_action_pressed(play_key) and is_hovered() and current_texture != back_texture:
			play_card()


func set_globals():
	use_shadow = CardGlobal.use_shadows
	play_key = CardGlobal.play_key


##Sets/creates the required conections and nodes for the card
func set_required():
	#Make button invisible
	self_modulate.a = 0
	
	#Signal Connections
	button_down.connect(on_button_down)
	button_up.connect(on_button_up)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	button_mask = MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT
	
	#manage resource
	if !card_resource:
		push_error("No card Resource")
		
	face_texture = card_resource.card_face
	back_texture = card_resource.card_back
		
	match start_face:
		"Back": current_texture = back_texture
		"Face": current_texture = face_texture
	set_tooltip()
	
	#Set size of the card
	card_size = face_texture.get_size()
	self.size = card_size
	pivot_offset = size/2
	
	#Create shadow effect
	if use_shadow:
		shadow_card = TextureRect.new()
		shadow_card.name = "Shadow"
		shadow_card.modulate = Color.BLACK
		shadow_card.self_modulate.a = 0.3
		shadow_card.texture = current_texture
		shadow_card.position.y = size.y * 0.1
		
		add_child(shadow_card)
	
	#Create card texture
	card_texture = CardTexture.new()
	card_texture.texture = current_texture
	card_texture.name = "Card Texture"
	add_child(card_texture)
	
	#glint shader
	if !material:
		material = ShaderMaterial.new()


func set_tooltip():
	if !CardGlobal.use_tooltips:
		return
	match current_texture:
		back_texture:
			tooltip_text = "Press MB2 to flip"
		face_texture:
			tooltip_text = card_resource.card_description


func on_button_down() -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = true
		dragging_offset = get_global_mouse_position() - position
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if current_texture == back_texture:
			card_texture.flip_card(face_texture, flip_duration)
			current_texture = face_texture
		elif current_texture == face_texture and card_resource.can_reflip:
			card_texture.flip_card(back_texture, flip_duration)
			current_texture = back_texture
		elif current_texture == face_texture and !card_resource.can_reflip:
			play_card()


func on_button_up() -> void:
	dragging = false


func on_dragged() -> void:
	if !is_draggable:
		return
	
	if dragging:
		position = (get_global_mouse_position() - dragging_offset)


func on_mouse_entered() -> void:
	_tween_hover(1.2)


func on_mouse_exited() -> void:
	_tween_hover(1, -1)
	card_texture.reset_rot()


func _tween_hover(_scale: float, _z: int = 1, _duration: float = 0.2) -> void:
	if hover_tween:
		hover_tween.kill()
	hover_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	hover_tween.tween_property(self, "scale", Vector2(_scale, _scale), _duration)
	z_index += _z


func handle_shadow() -> void:
	if !use_shadow:
		return
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float =global_position.x - center.x
	shadow_card.position.x = lerp(0.0, -sign(distance) * size.y * .1, abs(distance/center.x))


func play_card():
	card_resource.activate(self)
