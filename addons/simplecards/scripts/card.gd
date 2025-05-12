@icon("res://addons/simplecards/assets/icon_card.png")
extends Button
class_name Card

const CARD_FACE: CompressedTexture2D = preload("res://addons/simplecards/assets/card_blank.png")

var current_texture: CompressedTexture2D = null
var face_texture: CompressedTexture2D = null
var back_texture: CompressedTexture2D = null
var card_texture: CardTexture = null
var card_area: Area2D = null

var card_size: Vector2

@export var card_resource: CardResource = null


@export var is_draggable: bool = true
var dragging: bool = false
var dragging_offset: Vector2 = Vector2.ZERO

var use_shadow: bool = true
var shadow_card: TextureRect = null

#Tween Animating
var hover_tween: Tween
@export var flip_duration: float = 0.4

func _ready():
	set_required()
	set_globals()

func _process(delta):
	on_dragged()
	handle_shadow(delta)

func set_globals():
	use_shadow = CardGlobals.use_shadows


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
		
	current_texture = back_texture
	
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
	
	#Create missing dependencies
	card_texture = CardTexture.new()
	card_texture.texture = current_texture
	card_texture.name = "Card Texture"
	add_child(card_texture)
	
	#create card area
	card_area = Area2D.new()
	card_area.name = "Card Area"
	card_area.position = size/2
	var card_col = CollisionShape2D.new()
	card_col.name = "Card Colision"
	card_col.shape = RectangleShape2D.new()
	card_col.shape.size = card_size
	add_child(card_area)
	card_area.add_child(card_col)
	


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

func on_button_up() -> void:
	dragging = false
	if get_targets() != []:
		play_card()

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
	if !use_shadow:
		return
	
	var center: Vector2 = get_viewport_rect().size / 2.0
	var distance: float =global_position.x - center.x
	
	shadow_card.position.x = lerp(0.0, -sign(distance) * size.y * .1, abs(distance/center.x))


func play_card():
	card_resource.activate(get_targets())

func get_targets() -> Array:
	var targets: Array = []
	var target_areas = card_area.get_overlapping_areas()
	for area in target_areas:
		var temp = area.get_parent()
		targets.append(temp)
	
	return targets
