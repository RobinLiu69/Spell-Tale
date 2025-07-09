extends HBoxContainer

var bind_rows = {}
var waiting_for_action := ""

func _ready():
	setup_bind_rows()
	update_buttons()
	for action in bind_rows.keys():
		var button = bind_rows[action].get("button", null)
		bind_rows[action]["button"].pressed.connect(func():
			waiting_for_action = action
			bind_rows[action]["button"].text = "Press any key..."
		)
func setup_bind_rows():
	var container = $VBoxContainer
	for child in container.get_children():
		if child.name.begins_with("Rebind"):
			var action = child.name.replace("Rebind", "").to_snake_case()
			var button = child.get_node_or_null("Button")
			var label = child.get_node_or_null("ResultLabel")
			if button and label:
				bind_rows[action] = {
					"button": button,
					"label": label
				}
func _input(event):
	if waiting_for_action != "" and event is InputEventKey and event.pressed:
		var key_str = OS.get_keycode_string(event.keycode)
		for other_action in Global.keybindings.keys():
			if other_action != waiting_for_action and Global.keybindings[other_action] == key_str:
				bind_rows[waiting_for_action]["label"].text = "%s has bound to %s" % [key_str, other_action]
				update_buttons()
				waiting_for_action = ""
				return
				
		Global.keybindings[waiting_for_action] = key_str
		update_buttons()
		bind_rows[waiting_for_action]["label"].text = "successfully set to  %s" % key_str
		waiting_for_action = ""

func update_buttons():
	for action in bind_rows.keys():
		bind_rows[action]["button"].text = Global.keybindings.get(action, "-")
		
