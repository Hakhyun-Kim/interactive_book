extends Node

@onready var sky = $"SkyLayer/SkyGradient"
@onready var sub_title = $"UILayer/UIRoot/TitleVBox/SubTitle"
@onready var main_title = $"UILayer/UIRoot/TitleVBox/MainTitle"
@onready var main_title2 = $"UILayer/UIRoot/TitleVBox/MainTitle2"
@onready var author_label = $"UILayer/UIRoot/TitleVBox/AuthorLabel"
@onready var start_button = $"UILayer/UIRoot/TitleVBox/StartButton"
@onready var airplane = $"PlaneLayer/Airplane"

func _ready():
	# Animate sky gradient from night to dawn
	var sky_tween = create_tween()
	sky_tween.tween_property(sky, "color", Color(0.85, 0.92, 0.97, 1), 3.0)

	# Animate airplane flying across
	_launch_airplane()

	# Fade in title elements with stagger
	await get_tree().create_timer(1.2).timeout
	_fade_in(sub_title, 0.0)
	_fade_in(main_title, 0.5)
	_fade_in(main_title2, 1.0)
	_fade_in(author_label, 1.6)
	_fade_in(start_button, 2.2)

	await get_tree().create_timer(2.5).timeout
	if start_button:
		start_button.pressed.connect(_on_start_pressed)
		# Gentle pulse on button
		_pulse_button()

func _fade_in(node: Node, delay: float):
	var t = create_tween()
	t.tween_interval(delay)
	t.tween_property(node, "modulate:a", 1.0, 0.8).set_ease(Tween.EASE_OUT)

func _launch_airplane():
	if not airplane: return
	airplane.position = Vector2(-200, 380)
	var t = create_tween()
	# Fly from left to right with slight arc
	t.tween_property(airplane, "position", Vector2(1400, 300), 6.0).set_ease(Tween.EASE_IN_OUT)
	# After first pass wait then fly again
	t.tween_interval(3.0)
	t.tween_callback(_relaunch_airplane)

func _relaunch_airplane():
	if not airplane: return
	airplane.position = Vector2(-200, 500)
	var t = create_tween()
	t.tween_property(airplane, "position", Vector2(1400, 380), 7.0).set_ease(Tween.EASE_IN_OUT)
	t.set_loops()

func _pulse_button():
	if not start_button: return
	var t = create_tween().set_loops()
	t.tween_property(start_button, "modulate:a", 0.6, 1.0).set_ease(Tween.EASE_IN_OUT)
	t.tween_property(start_button, "modulate:a", 1.0, 1.0).set_ease(Tween.EASE_IN_OUT)

func _on_start_pressed():
	# Fade out whole scene then switch
	var t = create_tween()
	for layer in [$"SkyLayer", $"RainLayer", $"CloudsLayer", $"PlaneLayer", $"UILayer"]:
		t.parallel().tween_property(layer, "modulate:a", 0.0, 0.8)
	t.tween_callback(func(): get_tree().change_scene_to_file("res://scenes/book_reader.tscn"))

