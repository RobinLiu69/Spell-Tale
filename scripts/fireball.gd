extends CharacterBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var exisiting_timer: Timer = $ExisitingTimer

var damage: int = 3
var speed: int = 250
var existing_time: float = 10

var source: CharacterBody2D = null
var targets: Array[Node] = []


func _ready():
	if existing_time > 0:
		exisiting_timer.set_wait_time(existing_time)
		exisiting_timer.start()


func _process(delta):
	movement(delta)
	move_and_slide()



func movement(delta: float) -> bool:
	velocity = (Vector2.RIGHT * speed).rotated(rotation) * 2.5
	return true

	
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()

func hit(body: CharacterBody2D) -> void:
	velocity = Vector2.ZERO
	#anim.play("break", -1., 3)
	#await anim.animation_finished
	queue_free()


func stun():
	pass

func _on_stone_body_entered(body: Node2D) -> void:
	if body != source and body in targets:
		hit(body)


func _on_exisiting_timer_timeout() -> void:
	queue_free()
