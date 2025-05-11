@icon("res://addons/simplecards/assets/icon_card.png")
extends Button
class_name Card

const CARD_FACE: CompressedTexture2D = preload("res://addons/simplecards/assets/card_blank.png")

var main_texture: CompressedTexture2D = null
var face_texture: CompressedTexture2D = null
var back_texture: CompressedTexture2D = null
var card_texture: CardTexture = null

var card_size: Vector2

@export var card_resource: CardResource = null


@export var is_draggable: bool = true
var dragging: bool = false
var dragging_offset: Vector2 = Vector2.ZERO

@export var gen_shadow: bool = true
var shadow_card: TextureRect = null

#Tween Animating
var hover_tween: Tween


func _ready():
	set_required()

func _process(delta):
	on_dragged()
	handle_shadow(delta)


##Sets the required conections and nodes for the card
func set_required():
	#Make button invisible
	self_modulate.a = 0
	
	
	#Signal Connections
	button_down.connect(on_button_down)
	button_up.connect(on_button_up)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	
	#manage resource
	if card_resource:
		face_texture = card_resource.card_face
		back_texture = card_resource.card_back
	else:
		face_texture = CARD_FACE
		
	main_texture = face_texture
	
	#Set size of the card
	card_size = face_texture.get_size()
	self.size = card_size
	pivot_offset = size/2
	
	#Create shadow effect
	if gen_shadow:
		shadow_card = TextureRect.new()
		shadow_card.name = "Shadow"
		shadow_card.modulate = Color.BLACK
		shadow_card.self_modulate.a = 0.3
		shadow_card.texture = face_texture
		shadow_card.position.y = size.y * 0.1
		
		add_child(shadow_card)
	
	#Create missing dependencies
	card_texture = CardTexture.new()
	card_texture.texture = face_texture
	card_texture.name = "Card Texture"
		
	add_child(card_texture)


func on_button_down() -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = true
		dragging_offset = get_global_mouse_position() - position
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		if main_texture == face_texture:
			card_texture.flip_card(back_texture)
			main_texture = back_texture
		elif main_texture == back_texture:
			card_texture.flip_card(face_texture)
			main_texture = face_texture

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


func handle_shadow(delta: float) -> void:
	if !gen_shadow:
		return
	
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float =global_position.x - center.x
	
	shadow_card.position.x = lerp(0.0, -sign(distance) * size.y * .1, abs(distance/center.x))
