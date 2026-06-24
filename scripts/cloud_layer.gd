extends Node2D

@export var speed: float = 60.0
@export var y_position: float = 300.0
@export var cloud_color: Color = Color(1, 1, 1, 0.8)
@export var cloud_width: float = 260.0
@export var cloud_height: float = 90.0
@export var start_x: float = -300.0

var screen_width: float = 1080.0

func _ready():
	position.x = start_x
	position.y = y_position
	queue_redraw()

func _process(delta):
	position.x += speed * delta
	if position.x > screen_width + cloud_width:
		position.x = -cloud_width - 50.0
	queue_redraw()

func _draw():
	var c = cloud_color
	var w = cloud_width
	var h = cloud_height
	draw_puff(Vector2(0, 0),          Vector2(w * 0.40, h * 0.45), c)
	draw_puff(Vector2(-w * 0.28,  h * 0.08), Vector2(w * 0.28, h * 0.38), c)
	draw_puff(Vector2( w * 0.28,  h * 0.08), Vector2(w * 0.28, h * 0.38), c)
	draw_puff(Vector2(0,          -h * 0.18), Vector2(w * 0.22, h * 0.32), c)
	draw_puff(Vector2(0,           h * 0.20), Vector2(w * 0.45, h * 0.28), c)

func draw_puff(center: Vector2, radii: Vector2, color: Color, segments: int = 32):
	var points = PackedVector2Array()
	for i in range(segments + 1):
		var angle = (float(i) / float(segments)) * TAU
		points.append(center + Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	draw_colored_polygon(points, color)
