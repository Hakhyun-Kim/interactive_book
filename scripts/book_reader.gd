extends Node

@onready var book_title_label = $"UILayer/UIRoot/BookTitle"
@onready var scroll_container = $"UILayer/UIRoot/ContentScroll"
@onready var illustration_rect = $"UILayer/UIRoot/ContentScroll/MarginContainer/ScrollAlign/Illustration"
@onready var content_rich_label = $"UILayer/UIRoot/ContentScroll/MarginContainer/ScrollAlign/ContentText"
@onready var reflection_card = $"UILayer/UIRoot/ContentScroll/MarginContainer/ScrollAlign/ReflectionCard"
@onready var card_header = $"UILayer/UIRoot/ContentScroll/MarginContainer/ScrollAlign/ReflectionCard/CardVBox/CardHeader"
@onready var card_title = $"UILayer/UIRoot/ContentScroll/MarginContainer/ScrollAlign/ReflectionCard/CardVBox/CardHeader/HeaderHBox/CardTitle"
@onready var card_content = $"UILayer/UIRoot/ContentScroll/MarginContainer/ScrollAlign/ReflectionCard/CardVBox/CardContent"
@onready var prev_btn = $"UILayer/UIRoot/NavigationBar/PrevButton"
@onready var page_ind = $"UILayer/UIRoot/NavigationBar/PageIndicator"
@onready var next_btn = $"UILayer/UIRoot/NavigationBar/NextButton"

var current_page_index: int = 0
var image_cache: Dictionary = {}

func _ready():
	preload_images()
	if prev_btn: prev_btn.pressed.connect(_on_prev_button_pressed)
	if next_btn: next_btn.pressed.connect(_on_next_button_pressed)
	initialize_reader()

func preload_images():
	var sprite_names = ["book_cover", "illustration_chapter1", "illustration_chapter3", "illustration_chapter4", "illustration_chapter7"]
	for name in sprite_names:
		var res_path = "res://sprites/" + name + ".png"
		if not FileAccess.file_exists(res_path):
			print("File not found: ", res_path)
			continue
		var file = FileAccess.open(res_path, FileAccess.READ)
		if not file:
			print("Cannot open: ", res_path)
			continue
		var bytes = file.get_buffer(file.get_length())
		file.close()
		var img = Image.new()
		var err = img.load_png_from_buffer(bytes)
		if err != OK:
			# fallback: try JPEG
			err = img.load_jpg_from_buffer(bytes)
		if err == OK:
			image_cache[name] = ImageTexture.create_from_image(img)
			print("Preloaded OK: ", name, " (", bytes.size(), " bytes)")
		else:
			print("FAILED to decode image: ", name, " error=", err)

func initialize_reader():
	var book = BookDataManager.current_book
	if book.is_empty():
		push_error("BookDataManager: current_book is empty!")
		return
	if book_title_label:
		book_title_label.text = book.get("title", "에세이 리더")
	current_page_index = clamp(book.get("current_page", 1) - 1, 0, BookDataManager.flat_pages.size() - 1)
	display_page(current_page_index)

func display_page(index: int):
	var flat_pages = BookDataManager.flat_pages
	if flat_pages.is_empty() or index < 0 or index >= flat_pages.size():
		return
	current_page_index = index
	var page = flat_pages[index]

	if content_rich_label:
		content_rich_label.text = process_markdown_to_bbcode(page.get("content", ""))

	if illustration_rect:
		var img_url: String = page.get("imageUrl", "")
		var base_name = img_url.get_file()
		if image_cache.has(base_name):
			illustration_rect.texture = image_cache[base_name]
			illustration_rect.visible = true
		else:
			illustration_rect.visible = false

	setup_reflection_card(page)

	if prev_btn: prev_btn.disabled = current_page_index == 0
	if next_btn: next_btn.disabled = current_page_index == flat_pages.size() - 1
	if page_ind: page_ind.text = str(current_page_index + 1) + "  /  " + str(flat_pages.size())
	if scroll_container: scroll_container.scroll_vertical = 0

	BookDataManager.save_progress(current_page_index + 1)

	var chapter_id = BookDataManager.get_chapter_id_for_page_index(current_page_index)
	var bg = get_node_or_null("BackgroundLayer/LiveBackground")
	if bg and bg.has_method("change_effect"):
		bg.change_effect(chapter_id)

func setup_reflection_card(page: Dictionary):
	if not reflection_card: return
	var elements = page.get("interactiveElements", [])
	if elements.size() == 0:
		reflection_card.visible = false
		return
	reflection_card.visible = true
	var element = elements[0]
	var header_color = Color("c8b195")
	var title_text = "사색의 기록"
	match element.get("id", ""):
		"prologue_note":
			header_color = Color("8c7d70")
			title_text = "기록을 시작하며"
		"ch1_note":
			header_color = Color("c8b195")
			title_text = "부모를 위한 사색 노트"
		"ch3_note":
			header_color = Color("9ca088")
			title_text = "교직원 진솔의 비밀 주석"
		"ch4_note":
			header_color = Color("8f9ea6")
			title_text = "이중 언어 발달 팁"
		"ch7_note":
			header_color = Color("c98b75")
			title_text = "최종 선택을 위한 체크리스트"
	if card_header: card_header.color = header_color
	if card_title: card_title.text = title_text
	if card_content: card_content.text = element.get("label", "")

func _on_prev_button_pressed():
	if current_page_index > 0:
		display_page(current_page_index - 1)

func _on_next_button_pressed():
	if current_page_index < BookDataManager.flat_pages.size() - 1:
		display_page(current_page_index + 1)

func process_markdown_to_bbcode(markdown: String) -> String:
	if markdown == "": return ""
	var lines = markdown.split("\n")
	var result_lines: Array = []
	for line in lines:
		if line.begins_with("### "):
			result_lines.append("[font_size=19][b]" + line.substr(4) + "[/b][/font_size]")
		elif line.begins_with("## "):
			result_lines.append("[font_size=22][b]" + line.substr(3) + "[/b][/font_size]")
		elif line.begins_with("# "):
			result_lines.append("[font_size=26][b]" + line.substr(2) + "[/b][/font_size]")
		elif line.begins_with("> "):
			result_lines.append("[i][color=#5c5856]" + line.substr(2) + "[/color][/i]")
		else:
			result_lines.append(line)
	return "\n".join(result_lines)
