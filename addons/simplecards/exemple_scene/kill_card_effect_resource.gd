##Queues free the card on use
class_name KillCardEffectResource
extends EffectResource

func use(_targets: Array):
	_targets[0].queue_free()
