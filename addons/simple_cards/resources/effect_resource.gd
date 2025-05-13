##Main resource of the effects.
##
##Create scripts that extend this for creating custom effects. [br]
##
## Use the use function to trigger the effect.
##[codeblock]
##func use(_card: Card): put effect here
##[/codeblock]
@icon("res://addons/simple_cards/assets/icon_sword.png")
class_name EffectResource
extends Resource

func use(_card: Card):
	pass
