extends Component

@export var mana_component: ManaComponent
@export var accessory_elements: Array[String] = []  # 裝備提供的 mana 類型

func _ready():
	mana_component.set_mana_elements(accessory_elements)
