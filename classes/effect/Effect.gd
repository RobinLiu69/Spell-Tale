class_name Effect
extends Node

@export var component: EffectManagerComponent

var is_stopped := false
var duration := 1.0
var level := 1.0
var timer: Timer 
var old_behavior: Behavior = null	


func _init(_duration: float = 1.0, _level: float = 1.0):
	duration = _duration
	level = _level

func _ready():
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = duration
	add_child(timer)
	timer.start()

func update(delta: float):
	pass

func apply():
	pass

func remove():
	pass

func is_finished() -> bool:
	return timer.is_stopped() or is_stopped
