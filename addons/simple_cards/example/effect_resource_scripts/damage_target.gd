class_name DamageEffectResource
extends EffectResource

@export var damage_ammount: int = 3
@export var group: String = ""

func use(_card: Card):
	for target in CardGlobal.get_targets():
		if (target as Node).is_in_group(group):
			target.damage(damage_ammount)
