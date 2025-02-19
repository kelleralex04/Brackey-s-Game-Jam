extends Node2D

signal typing_finished

@onready var desktop: Node2D = $Desktop
@onready var example_email_label: Label = $Screen/ExampleEmailPanel/ExampleEmailLabel
@onready var email_input: email_class = $Screen/EmailInput
@onready var example_email: Panel = $Screen/ExampleEmailPanel
@onready var taskbar: HBoxContainer = $Taskbar
@onready var email_task: Control = $Taskbar/EmailTask
@onready var timer: Timer = $Timer
@onready var time_left: Label = $TimerPanel/TimeLeft
@onready var game_over_panel: Panel = $GameOverPanel
@onready var phone_panel: Panel = $PhonePanel
@onready var phone_caller_label: Label = $PhonePanel/PhoneVbox/PhoneCallerLabel
@onready var phone_company_label: Label = $PhonePanel/PhoneVbox/PhoneCompanyLabel
@onready var phone_reason_label: Label = $PhonePanel/PhoneVbox/PhoneReasonLabel
@onready var screen: TextureRect = $Screen
@onready var no_emails_panel: Panel = $Screen/NoEmailsPanel
@onready var close_email: Button = $Screen/CloseEmail
@onready var send: Button = $Screen/Send
@onready var calendar_panel: Panel = $Screen/CalendarPanel
@onready var contact_list: ItemList = $Screen/CalendarPanel/ContactList
@onready var contact_search: LineEdit = $Screen/CalendarPanel/ContactSearch
@onready var search_label: Label = $Screen/CalendarPanel/SearchLabel
@onready var add_attendee_1: Button = $Screen/CalendarPanel/AttendeesContainer/AddAttendee1

var minutes: int
var seconds: int
var milliseconds: int
#var open_panel := false
var desktop_opened := false
var phone_opened := false
var email_queue := []
var new_email: String
var cur_company: String
var cur_caller: String
var cur_reason: String
var cur_label: Label
var rand: int
var full_text: String
var typing_speed: float
var typewriter_index := 0
var typewriter_timer: Timer
var cur_attendee = 1

var email_responses: Dictionary = {
	1: "I'd explain why this won't work, but I have a feeling you're not big on listening to reason.",
	2: "It's cute that you think this is my problem.",
	3: "I appreciate your enthusiasm, even if the facts don't quite agree with you.",
	4: "I see we're embracing creativity over accuracy today.",
	5: "Fascinating request - I'll be sure to add it to my ever-growing list of miracles to perform.",
	6: "I admire your confidence in sending this.",
	7: "Let me take a deep breath before I begin.",
	8: "It's always refreshing to see such... unique interpretations of reality.",
	9: "I'll be sure to prioritize this right after all the other things that actually make sense.",
	10: "It's truly impressive how confidently incorrect this is.",
	11: "Oh great, another email that could have been a Google search.",
	12: "I see we're setting new records for bold assumptions today.",
	13: "I didn't think it was possible to be both vague and demanding, yet here we are.",
	14: "Interesting perspective - completely wrong, but interesting nonetheless.",
	15: "If only effort counted as accuracy, you'd be onto something here.",
	16: "I can't wait to see how you justify this one.",
	17: "Oh good, I was hoping for another reason to question my career choices today.",
	18: "Ah yes, let me just drop everything to fix a problem you created.",
	19: "I'd be happy to help - assuming, of course, that 'help' now means 'fix all your mistakes.'",
	20: "I'd explain why this is wrong, but I suspect you'd ignore it anyway.",
	21: "You must be exhausted from jumping to all these conclusions.",
	22: "I can already tell this is going to be a 'take a deep breath before responding' kind of email.",
	23: "It's almost impressive how many errors you fit into one request.",
	24: "If you keep moving the goalposts like this, we might as well play a different game.",
	25: "I see we're just saying things now with no regard for reality.",
	26: "Oh, fantastic. Another episode of 'I have no idea what I'm doing, so please fix it for me.'",
	27: "I appreciate your enthusiasm, even if your logic is wildly flawed.",
	28: "Let me just consult my crystal ball since no actual details were included.",
	29: "Your confidence in being incorrect is truly something to behold.",
	30: "I'd love to help, but unfortunately, I value my sanity.",
	31: "Bold move sending this email like I wouldn't notice the nonsense in it.",
	32: "I assume this was sent for comedic effect because otherwise, I'd be concerned.",
	33: "Oh good, an opportunity to practice patience I didn't ask for.",
	34: "Let me know when you've completed your warm-up round of bad ideas.",
	35: "You might be onto something here - though I'd recommend getting off of it immediately.",
	36: "This is the kind of email that makes me reconsider my life choices.",
	37: "I'd say 'nice try,' but that would imply an attempt at correctness was made.",
	38: "I can't tell if you're testing me or if this is genuinely how you think things work.",
	39: "I'll add this to my ever-growing list of problems I didn't create but now have to solve.",
	40: "If I had a dollar for every incorrect assumption in this email, I'd retire today.",
	41: "Let me guess - this is urgent because of your poor planning?",
	42: "Reading this was an adventure in patience I didn't sign up for.",
	43: "It's truly a wonder how you made it this far in life without basic comprehension skills.",
	44: "If this email had a soundtrack, it would just be clown music.",
	45: "I'll get right on this - as soon as I figure out how to time travel and warn past me not to open it.",
	46: "Your ability to avoid responsibility is nothing short of Olympic level.",
	47: "I assume spellcheck and logic were both on vacation when you wrote this.",
	48: "You really said all of this with a straight face, huh?",
	49: "Wow, I didn't realize we were just making up rules as we go.",
	50: "This is the kind of request that makes me wish I believed in ghosts - so one could do my job for me.",
	51: "You had one job, and somehow, I'm now the one doing it.",
	52: "You've officially unlocked a new level of audacity.",
	53: "I'd address the flaws in your logic, but I don't think we have that kind of time.",
	54: "This email has so many red flags I feel like I just walked into a bullfight.",
	55: "I could respond with facts, but I have a feeling you prefer fiction.",
	56: "I appreciate your confidence, but unfortunately, facts still exist.",
	57: "I see we're still treating accountability like a game of hot potato.",
	58: "I'd say 'never change,' but I think we'd all benefit if you did.",
	59: "This request is so unrealistic it should be classified as science fiction.",
	60: "Oh, so we're just making up deadlines now? Cool, cool.",
}
var company_employee = [
	["SynerTech Solutions", "Alice Carter", "Michael Bennett", "Sophia Ramirez"],
	["Nexora Consulting", "Daniel Harris", "Emma Patel", "Jacob Thompson"],
	["Synergex Innovations", "Oliver White", "Emily Parker", "Lucas Anderson"],
	["Stratosphere Global", "Grace Mitchell", "Nathan Scott", "Liam Rodriguez"],
	["Optimus Enterprises", "Mia Evans", "Ethan Foster", "Ava Cooper"],
	["Vertex Strategies", "Benjamin Walker", "Olivia Morris", "James Brooks"],
	["Bluewave Analytics", "Isabella Hall", "Alexander Reed", "Charlotte Adams"],
	["Peak Performance Partners", "William Stewart", "Amelia Carter", "Henry Gray"],
	["Quantum Edge Consulting", "Ella Jenkins", "Samuel Morgan", "Victoria Ross"],
	["Summit Synergy", "Noah Campbell", "Sophie Kelly", "Lily Flores"],
	["Evercore Dynamics", "Mason Barnes", "Harper Lewis", "Elijah Perry"],
	["Catalyst Ventures", "Aiden Hughes", "Zoe Ramirez", "Sebastian Carter"],
	["Apex Growth Solutions", "Lillian Bell", "David Sanders", "Evelyn Price"],
	["Zenith Corporate Solutions", "Caleb Fisher", "Madison Howard", "Jack Ward"],
	["Momentum Advisory Group", "Natalie Cook", "Dylan Richardson", "Leo Bryant"],
	["Elevate Business Solutions", "Scarlett Griffin", "Owen Wood", "Hailey Peterson"],
	["Paragon Strategic Partners", "Chloe Powell", "Julian Cox", "Penelope Hayes"],
	["Horizon Capital Group", "Matthew Foster", "Aubrey Morgan", "Daniel Russell"],
	["Fusion Enterprises", "Emily Simmons", "Wyatt Murphy", "Aria Collins"],
	["OmniVision Consulting", "Luke Hughes", "Savannah Price", "Joseph Parker"],
	["NovaSphere Solutions", "Victoria Bailey", "Benjamin Gonzalez", "Grace Long"],
	["Epicenter Business Solutions", "Andrew Rivera", "Isla Carter", "Gabriel Scott"],
	["Proxima Consulting Group", "Samantha Hayes", "Ryan Bennett", "Nathaniel Brooks"],
	["Beacon Strategy Partners", "Lydia Cooper", "Adam Flores", "Nora Bell"],
	["Titan Business Solutions", "Eleanor Howard", "Connor Fisher", "Hudson Griffin"],
	["Synergy Nexus", "Daisy Collins", "Cole Ramirez", "Aurora Peterson"],
	["Acumen Corporate Advisors", "Eva Morgan", "Carson Ward", "Ivy Stewart"],
	["Visionary Edge Consulting", "Asher Parker", "Layla Wood", "Easton Perry"],
	["Astute Advisory Group", "Zachary Price", "Bella Richardson", "Elliot Murphy"],
	["Veritas Growth Partners", "Stella Russell", "Axel Lewis", "Hazel Bryant"],
	["Summitwise Consulting", "Gianna Foster", "Miles Bell", "Ariana Hayes"],
	["Metrix Global Solutions", "Julian Simmons", "Alice Cook", "Beau Kelly"],
	["Excelsior Business Consulting", "Leonardo Hughes", "Melanie Powell", "Jameson Cox"],
	["AlphaCore Strategies", "Sarah Morgan", "Ezra Stewart", "Leilani Mitchell"],
	["Omnexus Solutions", "Madeline Adams", "Ryder Bailey", "Josephine Gonzalez"],
	["PrismEdge Consulting", "Xavier Carter", "Emilia Rivera", "Piper Scott"],
	["Centric Vision Partners", "Bennett Ramirez", "Delilah Brooks", "Adrian Cooper"],
	["Infinitum Business Consulting", "Kinsley Richardson", "Maxwell Perry", "Sydney Murphy"],
	["PrimePath Advisory", "Juliette Long", "Finn Ward", "Elise Flores"],
	["Northstar Strategic Advisors", "Lorenzo Griffin", "Brielle Peterson", "Victor Bennett"],
	["ElevateX Solutions", "Evangeline Parker", "Theo Morgan", "Callie Howard"],
	["Legacy Growth Partners", "Maddox Price", "Sadie Powell", "Jasper Simmons"],
	["Integra Advisory Group", "Bianca Lewis", "Camden Foster", "Annabelle Scott"],
	["StellarEdge Consulting", "Finnley Cook", "Rebecca Carter", "Dante Bell"],
	["Aspire Corporate Solutions", "Mikayla Collins", "Elliott Ward", "Rylee Bailey"],
	["Momentum Edge Partners", "Diana Ramirez", "Anderson Brooks", "Margot Gonzalez"],
	["NextGen Synergies", "Giselle Mitchell", "Jayden Wood", "Sienna Parker"],
	["Prospera Business Solutions", "Grayson Carter", "Anastasia Perry", "Micah Rivera"],
	["Pinnacle Vision Strategies", "Zane Stewart", "Tessa Cook", "Roman Bennett"],
	["Infinity Growth Advisors", "Dakota Bell", "Alina Kelly", "Tristan Howard"],
]
var reasons = [
	'Schedule Meeting',
	'Make Order',
	'Take Message'
]
var all_names = []

#Other tasks: order lunch, hand out lunch

func _ready() -> void:
	example_email_label.text = choose_email()
	email_queue.append([email_task, example_email_label.text])
	
	for i in company_employee:
		for j in 3:
			all_names.append(i[j + 1])
	
	all_names.sort()
	
	rand = randi_range(0, 49)
	cur_company = company_employee[rand][0]
	cur_caller = company_employee[rand][randi_range(1, 3)]
	cur_reason = reasons[randi_range(0, 2)]
	
	populate_list(all_names)

func _process(delta: float) -> void:
	var remaining_time = timer.time_left
	minutes = int(remaining_time) / 60
	seconds = int(remaining_time) % 60
	milliseconds = int((remaining_time - int(remaining_time)) * 100)
	time_left.text = str(minutes) + ":" + str(seconds).pad_zeros(2) + ":" + str(milliseconds).pad_zeros(2)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed('ui_accept') and desktop_opened:
		send_email()

func open_close(nodes: Array, open: bool):
	for i in nodes:
		i.visible = open

func send_email():
	if email_input.text == example_email_label.text:
		#_on_desktop_clicked()
		email_queue[0][0].queue_free()
		email_queue.pop_front()
		var temp_timer = Timer.new()
		await get_tree().create_timer(0.01).timeout
		email_input.text = ''
		if email_queue.size():
			example_email_label.text = email_queue[0][1]
			email_input.grab_focus()
		else:
			timer.set_paused(true)
			open_close([email_input, example_email, close_email, send], false)
	else:
		_on_desktop_clicked()
		game_over()

func choose_email() -> String:
	return email_responses[randi_range(1, 60)]

func _on_email_input_text_changed() -> void:
	var new_email_text: String = email_input.text
	if new_email_text.length() > example_email_label.text.length():
		email_input.text = email_input.cur_email_text
		email_input.set_caret_line(email_input.cursor_line)
		email_input.set_caret_column(email_input.cursor_column)
	
	email_input.cur_email_text = email_input.text
	email_input.cursor_line = email_input.get_caret_line()
	email_input.cursor_column = email_input.get_caret_column()
	
	for i in email_input.text.length():
		if email_input.text[i] != example_email_label.text[i]:
			email_input.add_theme_color_override('font_color', Color(1, 0, 0))
			break
		else:
			email_input.add_theme_color_override('font_color', Color(1, 1, 1))

func _on_desktop_clicked() -> void:
	#if email_queue.size():
		#if !open_panel or open_panel and desktop_opened:
			#open_panel = !open_panel
	desktop_opened = true
	screen.visible = true

func _on_phone_clicked() -> void:
	#if !open_panel or open_panel and phone_opened:
		#open_panel = !open_panel
	if phone_opened and get_child(-1) == typewriter_timer:
		typewriter_timer.set_paused(true)
	elif !phone_opened and get_child(-1) == typewriter_timer:
		typewriter_timer.set_paused(false)
	else:
		phone_call()
	phone_opened = !phone_opened
	phone_panel.visible = true

func phone_call():
	call_typewriter(phone_caller_label, 'Caller: ' + cur_caller)
	await typing_finished
	call_typewriter(phone_company_label, 'Company: ' + cur_company)
	await typing_finished
	call_typewriter(phone_reason_label, 'Reason: ' + cur_reason)

func call_typewriter(label: Label ,text: String):
	typewriter_timer = Timer.new()
	full_text = text
	cur_label = label
	typewriter_timer.wait_time = randf_range(0.05, 0.15)
	typewriter_timer.autostart = true
	typewriter_timer.one_shot = false
	typewriter_timer.timeout.connect(_on_typewriter_timer_timeout)
	add_child(typewriter_timer)

func _on_typewriter_timer_timeout():
	if typewriter_index < full_text.length():
		cur_label.text += full_text[typewriter_index]
		typewriter_index += 1
	else:
		typewriter_index = 0
		get_child(-1).queue_free()
		typing_finished.emit()

func _on_new_email_pressed() -> void:
	var email_task_scene = preload('res://Scenes/email_task.tscn')
	var new_email_task = email_task_scene.instantiate()
	email_queue.append([new_email_task, choose_email()])
	
	taskbar.add_child(new_email_task)

func _on_start_timer_pressed() -> void:
	timer.start(timer.wait_time)

func _on_timer_timeout() -> void:
	game_over()

func _on_restart_pressed() -> void:
	game_over_panel.visible = false

func game_over():
	game_over_panel.visible = true

func _on_close_screen_pressed() -> void:
	desktop_opened = false
	screen.visible = false

func _on_close_phone_pressed() -> void:
	_on_phone_clicked()

func _on_email_icon_clicked() -> void:
	if email_queue.size():
		example_email_label.text = email_queue[0][1]
		email_input.grab_focus()
		open_close([email_input, example_email, close_email, send], true)
	else:
		no_emails_panel.modulate.a = 1
		no_emails_panel.visible = true
		await get_tree().create_timer(1).timeout
		var tween = get_tree().create_tween()
		tween.tween_property(no_emails_panel, "modulate:a", 0, 1)

func _on_close_email_pressed() -> void:
	open_close([email_input, example_email, close_email, send], false)

func _on_send_pressed() -> void:
	send_email()

func _on_calendar_icon_clicked() -> void:
	calendar_panel.visible = true

func populate_list(names):
	contact_list.clear()
	for name in names:
		contact_list.add_item(name)

func filter_names(new_text):
	if !new_text:
		populate_list(all_names)
	else:
		var filtered = []
		for name in all_names:
			if new_text.to_lower() in name.to_lower():
				filtered.append(name)
		populate_list(filtered)

func _on_contact_search_text_changed(new_text: String) -> void:
	filter_names(new_text)

func _on_add_attendee_1_pressed() -> void:
	open_close([contact_list, contact_search, search_label], true)

func _on_contact_list_item_selected(index: int) -> void:
	add_attendee_1.text = contact_list.get_item_text(index)

func _on_contact_list_item_activated(index: int) -> void:
	add_attendee_1.disabled = true
	open_close([contact_list, contact_search, search_label], false)
