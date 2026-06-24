extends Node2D

@export var sparkle_prefab: PackedScene
@export var particle_duration: float = 1.5

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			trigger_touch_effect(event.position)
	elif event is InputEventScreenTouch:
		if event.pressed:
			trigger_touch_effect(event.position)

func trigger_touch_effect(screen_pos: Vector2):
	if not sparkle_prefab:
		return
		
	# Instantiate the sparkle particle system
	var effect_instance = sparkle_prefab.instantiate()
	
	# Add child and set position in world space
	add_child(effect_instance)
	effect_instance.global_position = get_canvas_transform().affine_inverse() * screen_pos
	
	# Auto destroy after the particles finish playing
	var timer = get_tree().create_timer(particle_duration)
	timer.timeout.connect(func(): effect_instance.queue_free())
