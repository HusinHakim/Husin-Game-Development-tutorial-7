extends RayCast3D

@onready var interact_prompt: Label = %InteractPrompt

func _process(delta):
	var collider = get_collider()

	if is_colliding() and collider != null:
		# Interact switch
		if collider is Interactable:
			if Input.is_action_just_pressed("interact"):
				collider.interact()

		# Pickup torch pakai E
		if collider is Torch:
			interact_prompt.visible = true
			if Input.is_action_just_pressed("interact"):
				var added = Inventory.add_item("Torch", {"type": "torch"})
				if added:
					collider.queue_free()
		else:
			interact_prompt.visible = false
	else:
		interact_prompt.visible = false
