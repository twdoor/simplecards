##Resource used for initilizing a card.
@icon("res://addons/simple_cards/assets/icon_card_res.png")
class_name CardResource
extends Resource

@export var card_face: CompressedTexture2D
@export var card_back: CompressedTexture2D

@export var card_description: String = ""

@export var can_reflip: bool = false
@export var effects: Array[EffectResource]
var targets: Array


func activate(_card: Card):
	for effect in effects:
		effect.use(_card)
