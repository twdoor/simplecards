##Changes all targets into a selectable color
class_name ColorEffectResource
extends EffectResource

@export var color: Color

func use(_targets: Array):
	for target in _targets:
		target.modulate = color
