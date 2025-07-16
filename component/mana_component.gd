extends Component
class_name ManaComponent

var max_mana: Dictionary = {
	"fire": 10,
	"water": 10,
	"earth": 10,
	"grass": 10,
	"electric": 10,
	"light": 10,
	"dark": 10,
}
@export var current_mana: Dictionary = {
	"fire": 0,
	"water": 0,
	"earth": 0,
	"grass": 0,
	"electric": 0,
	"light": 0,
	"dark": 0,
}

@export var regen_elements: Array[String] = []
@export var regen_interval: float = 2.0
@export var regen_enabled: bool = true

var gain_log: Array[String] = []
@export var gain_log_max_len: int = 20

var _regen_timers: Dictionary = {}

signal mana_changed(current_mana)

func _ready():
	for element in regen_elements:
		_regen_timers[element] = 0.0
	var element_array: Array[String] = [Global.selected_element]
	set_regen_elements(element_array)

func _process(delta: float) -> void:
	update_component(delta)

func update_component(delta: float) -> void:
	if not regen_enabled:
		return

	for element in regen_elements:
		if !_regen_timers.has(element):
			_regen_timers[element] = 0.0

		_regen_timers[element] += delta

		var interval = regen_interval
		if regen_elements.size() > 1:
			interval *= 1.25

		if _regen_timers[element] >= interval:
			gain_mana(element, 1)
			_regen_timers[element] = 0.0

func gain_mana(element: String, amount: int) -> void:
	if not current_mana.has(element) or not max_mana.has(element):
		return

	var old_value = current_mana[element]
	current_mana[element] = clamp(current_mana[element] + amount, 0, max_mana[element])
	
	if current_mana[element] > old_value:
		for i in amount:
			_add_to_gain_log(element)
		emit_signal("mana_changed", current_mana)

@rpc("authority")
func has_enough_multi(cost_dict: Dictionary) -> bool:
	for element in cost_dict.keys():
		if current_mana.get(element, 0) < cost_dict[element]:
			return false
	return true

@rpc("any_peer", "call_local")
func use_mana_multi(cost_dict: Dictionary) -> bool:
	if not has_enough_multi(cost_dict):
		return false
	for element in cost_dict.keys():
		current_mana[element] -= cost_dict[element]
		
	emit_signal("mana_changed", current_mana)
	rpc("sync_mana", current_mana)
	
	return true
	
@rpc("any_peer", "call_local")
func sync_mana(current: Dictionary):
	current_mana = current
	emit_signal("mana_changed", current_mana)



func set_regen_elements(elements: Array[String]) -> void:
	regen_elements = elements
	regen_enabled = elements.size() > 0
	for element in elements:
		_regen_timers[element] = 0.0

func set_mana_limit(element: String, max_value: int, current_value: int = -1) -> void:
	max_mana[element] = max_value
	current_mana[element] = current_value if current_value >= 0 else max_value

func _add_to_gain_log(element: String) -> void:
	gain_log.append(element)
	if gain_log.size() > gain_log_max_len:
		gain_log.pop_front()

func reset():
	#for element in max_mana.keys():
		#current_mana[element] = max_mana[element]
	emit_signal("mana_changed", current_mana)
	for element in regen_elements:
		_regen_timers[element] = 0.0
