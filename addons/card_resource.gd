extends Resource
class_name CardResource

@export var card_face: CompressedTexture2D
@export var card_back: CompressedTexture2D


@export var can_reflip: bool = false

@export_enum("GENERAL", "SINGLE_TARGET", "MULTITARGET") var type = 0
var targets: Array

func activate():
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
	pass
	
func multi_target_use(_targets: Array):
	pass

func get_target():
	pass
