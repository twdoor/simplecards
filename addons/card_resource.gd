extends Resource
class_name CardResource

@export var card_face: CompressedTexture2D
@export var card_back: CompressedTexture2D


@export var can_reflip: bool = false

@export_enum("GENERAL", "SINGLE_TARGET", "MULTITARGET") var type = 0
var targets: Array

@export var effect_array: Array


func activate(_targets: Array = []):
	targets = _targets
	match type:
		0:
			use()
		1:
			target_use(targets[0])
		2:
			multi_target_use(targets)

func use():
	print("Played")
	
func target_use(_target: Node):
	print("Used on " + str(targets[0].name))
	
func multi_target_use(_targets: Array):
	var targets: String = ""
	for target in _targets:
		targets += (target.name + " ")
	print("Used on " + targets)
