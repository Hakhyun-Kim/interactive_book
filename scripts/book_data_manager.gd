extends Node

var current_book: Dictionary = {}
var flat_pages: Array = []
var books: Array = []

func _ready():
	load_data()

func load_data():
	var file = FileAccess.open("res://data/book_data.json", FileAccess.READ)
	if file:
		var json_text = file.get_as_text()
		var json = JSON.new()
		var error = json.parse(json_text)
		if error == OK:
			var data = json.data
			if data.has("books"):
				books = data["books"]
				if books.size() > 0:
					select_book(books[0])
			print("Book Data loaded successfully.")
		else:
			print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())
	else:
		print("Failed to open book_data.json.")

func select_book(book: Dictionary):
	current_book = book
	flat_pages.clear()
	if book.has("chapters"):
		for chapter in book["chapters"]:
			if chapter.has("pages"):
				for page in chapter["pages"]:
					flat_pages.append(page)
	
	# Load Progress
	var config = ConfigFile.new()
	var err = config.load("user://save_data.cfg")
	if err == OK:
		current_book["current_page"] = config.get_value("Progress", "book_" + str(book["id"]), 1)
	else:
		current_book["current_page"] = 1

func save_progress(page_number: int):
	if current_book.is_empty():
		return
	current_book["current_page"] = page_number
	var config = ConfigFile.new()
	config.load("user://save_data.cfg") # Ignore read error for first run
	config.set_value("Progress", "book_" + str(current_book["id"]), page_number)
	config.save("user://save_data.cfg")
	print("Saved progress: Page ", page_number)

func get_chapter_id_for_page_index(page_index: int) -> String:
	if current_book.is_empty() or not current_book.has("chapters"):
		return ""
		
	var current_idx = 0
	for chapter in current_book["chapters"]:
		if chapter.has("pages"):
			for page in chapter["pages"]:
				if current_idx == page_index:
					return chapter["id"]
				current_idx += 1
	return ""
