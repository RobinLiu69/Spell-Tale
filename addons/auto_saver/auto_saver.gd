# addons/auto_saver/auto_saver.gd
@tool
extends EditorPlugin

var timer := Timer.new()

func _enter_tree():
	add_child(timer)
	timer.wait_time = 60
	timer.one_shot = false
	timer.autostart = true
	timer.timeout.connect(_on_timeout)
	timer.start()

func _on_timeout():
	var scene = get_editor_interface().get_edited_scene_root()
	if scene:
		get_editor_interface().save_scene()
