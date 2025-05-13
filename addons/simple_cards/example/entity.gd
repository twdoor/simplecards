extends Sprite2D

@export var max_health: int = 10
var health: int = 0:
	set(v):
		health = v
		if health > max_health:
			health = max_health
		if health <= 0:
			health = 0
			death()

@export var health_bar: ProgressBar

func _ready():
	health = max_health
	health_bar.max_value = max_health
	
func _process(delta):
	health_bar.value = health

func heal(value: int):
	health += value
	
func damage(value: int):
	health -= value

func death():
	queue_free()
