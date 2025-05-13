@icon("res://addons/simplecards/assets/icon_card_res.png")
##Resource used for initilizing a card.
class_name CardResource
extends Resource

@export var card_face: CompressedTexture2D
@export var card_back: CompressedTexture2D

@export var card_description: String = ""

@export var can_reflip: bool = false
@export var effects: Array[EffectResource]
var targets: Array


func activate(_targets: Array = []):
	for effect in effects:
		effect.use(_targets)
