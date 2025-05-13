class_name HealEffectResource
extends EffectResource

@export var heal_ammount: int = 3
@export var group: String = ""

func use(_card: Card):
	for target in CardGlobal.get_targets():
		if (target as Node).is_in_group(group):
			target.heal(heal_ammount)
