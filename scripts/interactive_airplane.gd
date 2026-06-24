extends Node2D

enum State { CRUISE, FLY_TO_TARGET, LOOPING }
var current_state: State = State.CRUISE

var speed: float = 120.0
var cruise_y: float = 400.0
var target_pos: Vector2 = Vector2.ZERO
var target_angle: float = 0.0

# For looping state
var loop_timer: float = 0.0
var loop_duration: float = 1.0
var loop_start_angle: float = 0.0

@onready var contrail = $Contrail

func _ready():
	# Position at start of screen
	position = Vector2(-150, cruise_y)
	scale = Vector2(0.5, 0.5)
	rotation = 0.0
	queue_redraw()

func _input(event):
	if not is_visible_in_tree():
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Do not respond if clicking navigation buttons (bottom area Y > 1800)
		if event.position.y > 1800: return
		set_target(event.position)
	elif event is InputEventScreenTouch and event.pressed:
		if event.position.y > 1800: return
		set_target(event.position)

func set_target(pos: Vector2):
	target_pos = pos
	current_state = State.FLY_TO_TARGET
	# Quick speed boost when chased
	speed = 280.0

func _process(delta):
	match current_state:
		State.CRUISE:
			# Fly straight right, gently return to cruise_y
			position.x += speed * delta
			position.y = move_toward(position.y, cruise_y, 40.0 * delta)
			rotation = rotate_toward(rotation, 0.0, 1.5 * delta)
			
			# Wrap around screen
			if position.x > 1200:
				position.x = -150
				cruise_y = randf_range(250, 800)
				position.y = cruise_y
				speed = randf_range(100, 140)

		State.FLY_TO_TARGET:
			# Calculate direction
			var to_target = target_pos - position
			var dist = to_target.length()
			
			if dist < 15.0:
				# Arrived! Do loop-de-loop
				current_state = State.LOOPING
				loop_timer = 0.0
				loop_start_angle = rotation
			else:
				# Steer towards target
				target_angle = to_target.angle()
				rotation = rotate_toward(rotation, target_angle, 4.0 * delta)
				
				# Move forward in current rotation direction
				var dir = Vector2.from_angle(rotation)
				position += dir * speed * delta

		State.LOOPING:
			# Loop-de-loop: full 360 degree spin
			loop_timer += delta
			var progress = loop_timer / loop_duration
			if progress >= 1.0:
				current_state = State.CRUISE
				speed = randf_range(110, 150)
			else:
				# Fly in a circle
				rotation = loop_start_angle - progress * TAU
				var dir = Vector2.from_angle(rotation)
				position += dir * 180.0 * delta

	queue_redraw()

func _draw():
	# Vector-draw a beautiful airplane (drawn pointing right at 0 degrees)
	# Fuselage
	draw_oval(Vector2(0, 0), Vector2(75, 14), Color(0.95, 0.95, 0.97))
	# Nose cone
	draw_colored_polygon(PackedVector2Array([
		Vector2(75, 0), Vector2(55, -9), Vector2(55, 9)
	]), Color(0.82, 0.85, 0.9))
	# Main wing
	draw_colored_polygon(PackedVector2Array([
		Vector2(-10, 0), Vector2(30, 0),
		Vector2(20, -52), Vector2(-30, -52)
	]), Color(0.85, 0.88, 0.93))
	# Wing highlight
	draw_colored_polygon(PackedVector2Array([
		Vector2(-5, -2), Vector2(25, -2),
		Vector2(17, -42), Vector2(-20, -42)
	]), Color(0.93, 0.95, 0.98, 0.5))
	# Tail fin
	draw_colored_polygon(PackedVector2Array([
		Vector2(-55, 0), Vector2(-40, 0),
		Vector2(-48, -30), Vector2(-68, -30)
	]), Color(0.82, 0.85, 0.9))
	# Stabilizer
	draw_colored_polygon(PackedVector2Array([
		Vector2(-50, 0), Vector2(-30, 0),
		Vector2(-28, -18), Vector2(-55, -18)
	]), Color(0.88, 0.90, 0.94))
	# Windows
	for i in range(5):
		draw_oval(Vector2(-20 + i * 18, -6), Vector2(6, 5), Color(0.65, 0.82, 0.95, 0.85))
	# Engine pod
	draw_oval(Vector2(10, 16), Vector2(22, 8), Color(0.75, 0.78, 0.82))
	draw_oval(Vector2(10, 16), Vector2(10, 6), Color(0.4, 0.4, 0.45))

func draw_oval(center: Vector2, radii: Vector2, color: Color, segments: int = 24):
	var pts = PackedVector2Array()
	for i in range(segments + 1):
		var a = (float(i) / float(segments)) * TAU
		pts.append(center + Vector2(cos(a) * radii.x, sin(a) * radii.y))
	draw_colored_polygon(pts, color)
