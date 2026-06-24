extends Node2D

func _draw():
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

