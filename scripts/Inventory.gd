extends Node

const MAX_SLOTS = 5
var slots: Array = []
var selected_slot: int = 0

signal inventory_changed

func _ready():
	slots.resize(MAX_SLOTS)
	for i in MAX_SLOTS:
		slots[i] = null

func add_item(item_name: String, item_data: Dictionary) -> bool:
	for i in MAX_SLOTS:
		if slots[i] == null:
			slots[i] = {"name": item_name, "data": item_data}
			emit_signal("inventory_changed")
			return true
	print("Inventory penuh!")
	return false

func remove_item(slot_index: int):
	slots[slot_index] = null
	emit_signal("inventory_changed")

func get_selected_item() -> Dictionary:
	return slots[selected_slot] if slots[selected_slot] != null else {}

func _input(event):
	# Tombol 1-5
	if event is InputEventKey:
		for i in MAX_SLOTS:
			if event.keycode == KEY_1 + i and event.pressed:
				selected_slot = i
				emit_signal("inventory_changed")

	# Scroll wheel
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				selected_slot = (selected_slot - 1 + MAX_SLOTS) % MAX_SLOTS
				emit_signal("inventory_changed")
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				selected_slot = (selected_slot + 1) % MAX_SLOTS
				emit_signal("inventory_changed")
