class_name CameraFollowComponent
extends Node

@export var camera_2d: Camera2D
var enabled := false

func set_enabled(state: bool):
	enabled = state
	if camera_2d:
		camera_2d.enabled = state

func update_offset(target_pos: Vector2):
	if not enabled or camera_2d == null:
		return
	var player_pos: Vector2 = camera_2d.get_parent().global_position
	var offset_x = (target_pos.x - player_pos.x) / (1920.0 / 50.0)
	var offset_y = (target_pos.y - player_pos.y) / (1080.0 / 50.0)
	camera_2d.offset = Vector2(offset_x, offset_y)
