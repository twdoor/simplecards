##Changes group of targets into a selectable color
class_name ColorEffectResource
extends EffectResource

@export var color: Color
@export var group: String = ""

func use(_card: Card):
	for target: Node2D in CardGlobal.get_targets():
		if group == "":
			target.modulate = color
		elif target.is_in_group(group):
			target.modulate = color
