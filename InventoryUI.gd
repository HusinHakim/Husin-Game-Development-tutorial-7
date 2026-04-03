extends CanvasLayer

@onready var hotbar: HBoxContainer = $Hotbar

var slot_nodes: Array = []

func _ready():
	Inventory.inventory_changed.connect(_update_ui)
	_build_hotbar()
	_update_ui()

func _build_hotbar():
	for i in Inventory.MAX_SLOTS:
		var panel = PanelContainer.new()
		panel.custom_minimum_size = Vector2(64, 64)
		
		var label = Label.new()
		label.name = "Label"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		panel.add_child(label)
		
		hotbar.add_child(panel)
		slot_nodes.append(panel)

func _update_ui():
	for i in Inventory.MAX_SLOTS:
		var label = slot_nodes[i].get_node("Label")
		var item = Inventory.slots[i]
		
		if item != null:
			label.text = item["name"]
		else:
			label.text = ""
		
		# Highlight slot yang dipilih
		if i == Inventory.selected_slot:
			slot_nodes[i].modulate = Color(1, 1, 0)  # kuning
		else:
			slot_nodes[i].modulate = Color(1, 1, 1)  # putih
