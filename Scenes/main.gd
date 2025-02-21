extends Node2D

signal typing_finished
signal boss_speech_finished
signal player_speech_finished

@onready var desktop: Node2D = $Desktop
@onready var example_email_label: Label = $Screen/ExampleEmailPanel/ExampleEmailLabel
@onready var email_input: email_class = $Screen/EmailInput
@onready var example_email: Panel = $Screen/ExampleEmailPanel
@onready var taskbar_panel: Panel = $TaskbarPanel
@onready var email_count_label: Label = $TaskbarPanel/EmailCountLabel
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
@onready var add_attendee_2: Button = $Screen/CalendarPanel/AttendeesContainer/AddAttendee2
@onready var add_attendee_3: Button = $Screen/CalendarPanel/AttendeesContainer/AddAttendee3
@onready var continue_call: Button = $PhonePanel/ContinueCall
@onready var phone_vbox: VBoxContainer = $PhonePanel/PhoneVbox
@onready var meeting_vbox: VBoxContainer = $PhonePanel/MeetingVbox
@onready var meeting_attendees_label: Label = $PhonePanel/MeetingVbox/MeetingAttendees
@onready var meeting_date_label: Label = $PhonePanel/MeetingVbox/MeetingDate
@onready var meeting_time_label: Label = $PhonePanel/MeetingVbox/MeetingTime
@onready var month_picker: OptionButton = $Screen/CalendarPanel/MonthPicker
@onready var day_picker: SpinBox = $Screen/CalendarPanel/DayPicker
@onready var hour_picker: SpinBox = $Screen/CalendarPanel/HourPicker
@onready var minute_picker: SpinBox = $Screen/CalendarPanel/MinutePicker
@onready var meeting_count_label: Label = $TaskbarPanel/MeetingCountLabel
@onready var hang_up: Button = $PhonePanel/HangUp
@onready var no_meetings_panel: Panel = $Screen/NoMeetingsPanel
@onready var text_scroll: AudioStreamPlayer = $TextScroll
@onready var blocker: ColorRect = $Blocker
@onready var day_label: Label = $DayLabel
@onready var boss_audio: AudioStreamPlayer = $BossSpeech/BossAudio
@onready var boss_speech_label: Label = $BossSpeech/BossSpeechLabel
@onready var boss_speech: TextureRect = $BossSpeech
@onready var boss_speech_tick: Label = $BossSpeech/BossSpeechTick
@onready var player_speech_label: Label = $PlayerSpeech/PlayerSpeechLabel
@onready var player_audio: AudioStreamPlayer = $PlayerSpeech/PlayerAudio
@onready var player_speech_tick: Label = $PlayerSpeech/PlayerSpeechTick
@onready var player_speech: TextureRect = $PlayerSpeech
@onready var john_office: TextureRect = $JohnOffice
@onready var boss: TextureRect = $Boss
@onready var boss_2: TextureRect = $Boss2

var minutes: int
var seconds: int
var milliseconds: int
#var open_panel := false
var desktop_opened := false
var phone_opened := false
var email_queue := []
var meeting_queue := []
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
var cur_attendee_button_index := 0
var cur_attendee_button: Button
var meeting_attendees: Array
var email_opened := false
var icon_opened := false
var email_count := 0
var typing := false
var call_finished := false
var hang_up_status := false
var advance_dialogue := false
var skip_typewriter := false
var typewriter_finished := false

var calendar_list: Array = [
	['Jan', 31],
	['Feb', 29],
	['Mar', 31],
	['Apr', 30],
	['May', 31],
	['Jun', 30],
	['Jul', 31],
	['Aug', 31],
	['Sep', 30],
	['Oct', 31],
	['Nov', 30],
	['Dec', 31]
]
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
	'Book Flight',
]
var all_names = []
var attendee_buttons: Array
var dialogue_text := [
	['Ah, Mr. Hawthorne! It\'s so nice to meet you, my name\'s...', 0],
	['Yeah that\'s great kid. You got any questions before you get started?', 1],
	['I guess I\'m just a bit confused... What is it we do here exactly?', 0],
	['We\'re a consulting company that helps other consulting companies find innovative technical solutions to real world', 1],
	['problems in the Web3 and Web4 spaces while providing SAAS and synergy across all areas of modern day business.', 1],
	['...', 0],
	['... What?', 0],
	['Look, don\'t concern yourself on what we do, just focus on what you do.', 1],
	['Which is?', 0],
	['Well today you\'re going to start off by responding to emails for me.', 1],
	['I\'ve already dictated them and had our in-house AI make them a bit less... colorful.', 1],
	['All you need to do is copy the responses and send them out to the right people, think you can handle that?', 1],
	['Wait, but if the AI already has the response ready, why do I need to type it up and send it?', 0],
	['Look kid, do you want the job or not?', 1],
	['Oh uh yes sir, I\'ll get right on it.', 0],
	'break'
]
var dialogue_tracker := 0
@onready var speakers = [player_speech_label, boss_speech_label]

#Other tasks: order lunch, hand out lunch

func _ready() -> void:
	open_close([blocker, day_label], true)
	var line_edit = hour_picker.get_line_edit()
	line_edit.context_menu_enabled = false
	line_edit = minute_picker.get_line_edit()
	line_edit.context_menu_enabled = false
	line_edit = day_picker.get_line_edit()
	line_edit.context_menu_enabled = false
	
	typing_speed = 0.025
	format_time(minute_picker.value, minute_picker)
	format_time(hour_picker.value, hour_picker)
	
	cur_attendee_button = add_attendee_1
	attendee_buttons = [add_attendee_1, add_attendee_2, add_attendee_3]
	
	#example_email_label.text = choose_email()
	#email_queue.append([email_task, example_email_label.text])
	
	for i in company_employee:
		for j in 3:
			all_names.append(i[j + 1])
	
	all_names.sort()
	
	populate_list(all_names)
	
	var tween1 = get_tree().create_tween()
	tween1.tween_property(day_label, "modulate:a", 0, 3)
	await get_tree().create_timer(2.0).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(blocker, "modulate:a", 0, 3)
	await get_tree().create_timer(2.0).timeout
	day_label.visible = false
	
	boss_speech.visible = true
	boss_speak('Hey there, I had heard we had a new hire! Hope you\'re enjoying your first day at DigiTech Innovative Solutions Incorporated.')

func _process(delta: float) -> void:
	var remaining_time = timer.time_left
	minutes = int(remaining_time) / 60
	seconds = int(remaining_time) % 60
	milliseconds = int((remaining_time - int(remaining_time)) * 100)
	time_left.text = str(minutes) + ":" + str(seconds).pad_zeros(2) + ":" + str(milliseconds).pad_zeros(2)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed('ui_accept') and email_opened:
		send_email()
	
	if Input.is_action_just_pressed('ui_select') and blocker.visible:
		if typewriter_finished == false and blocker.visible:
			skip_typewriter = true
		else:
			if typeof(dialogue_text[dialogue_tracker]) != 28:
				#john_office.flip_h = false
				boss.visible = false
				boss_2.visible = true
				blocker.visible = false
				open_close([boss_speech, boss_speech_tick, player_speech, player_speech_tick], false)
			else:
				skip_typewriter = false
				next_dialogue(dialogue_tracker)

func open_close(nodes: Array, open: bool):
	for i in nodes:
		i.visible = open

func boss_speak(text: String):
	boss_audio.play()
	call_typewriter(boss_speech_label, text)
	await typing_finished
	boss_audio.stop()
	boss_speech_finished.emit()
	
func player_speak(text: String):
	player_audio.play()
	call_typewriter(player_speech_label, text)
	await typing_finished
	player_audio.stop()
	player_speech_finished.emit()

func _on_player_speech_finished() -> void:
	player_speech_tick.visible = true
	#advance_dialogue = true

func _on_boss_speech_finished() -> void:
	boss_speech_tick.visible = true
	#advance_dialogue = true

func next_dialogue(index: int):
	var speaker = speakers[dialogue_text[index][1]]
	speaker.text = ''
	if speaker == player_speech_label:
		open_close([boss_speech, boss_speech_tick], false)
		player_speech.visible = true
		player_speak(dialogue_text[index][0])
	else:
		open_close([player_speech, player_speech_tick], false)
		boss_speech.visible = true
		boss_speak(dialogue_text[index][0])
	dialogue_tracker += 1

func send_email():
	if email_input.text == example_email_label.text:
		#_on_desktop_clicked()
		#email_queue[0][0].queue_free()
		email_queue.pop_front()
		email_count_label.text = str(email_queue.size())
		var temp_timer = Timer.new()
		await get_tree().create_timer(0.01).timeout
		email_input.text = ''
		if email_queue.size():
			example_email_label.text = email_queue[0][1]
			email_input.grab_focus()
		else:
			icon_opened = false
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
	skip_typewriter = false
	#if !open_panel or open_panel and phone_opened:
		#open_panel = !open_panel
	if phone_opened and typing:
		typewriter_timer.set_paused(true)
	elif !phone_opened and typing:
		typewriter_timer.set_paused(false)
	elif call_finished or hang_up_status:
		pass
	else:
		phone_call()
	phone_opened = !phone_opened
	phone_panel.visible = !phone_panel.visible
	hang_up_status = false

func phone_call():
	typing = true
	new_call()
	text_scroll.play()
	call_typewriter(phone_caller_label, 'Caller:\n' + cur_caller)
	await typing_finished
	call_typewriter(phone_company_label, 'Company:\n' + cur_company)
	await typing_finished
	call_typewriter(phone_reason_label, 'Reason:\n' + cur_reason)
	await typing_finished
	text_scroll.stop()
	call_finished = true
	continue_call.visible = true
	typing = false

func new_call():
	rand = randi_range(0, 49)
	cur_company = company_employee[rand][0]
	cur_caller = company_employee[rand][randi_range(1, 3)]
	#cur_reason = reasons[randi_range(0, 2)]
	cur_reason = reasons[0]

func call_typewriter(label: Label ,text: String):
	typewriter_finished = false
	typewriter_timer = Timer.new()
	full_text = text
	cur_label = label
	typewriter_timer.wait_time = typing_speed
	typewriter_timer.autostart = true
	typewriter_timer.one_shot = false
	typewriter_timer.timeout.connect(_on_typewriter_timer_timeout)
	add_child(typewriter_timer)

func _on_typewriter_timer_timeout():
	if skip_typewriter:
		cur_label.text = full_text
		typewriter_finished = true
		typewriter_index = 0
		typewriter_timer.queue_free()
		typing_finished.emit()
		return

	if typewriter_index < full_text.length():
		cur_label.text += full_text[typewriter_index]
		typewriter_index += 1
	else:
		typewriter_finished = true
		typewriter_index = 0
		typewriter_timer.queue_free()
		typing_finished.emit()

func _on_new_email_pressed() -> void:
	var email_task_scene = preload('res://Scenes/email_task.tscn')
	var new_email_task = email_task_scene.instantiate()
	email_queue.append([new_email_task, choose_email()])
	email_count_label.text = str(email_queue.size())

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

func _on_hold_phone_pressed() -> void:
	_on_phone_clicked()

func _on_email_icon_clicked() -> void:
	if !icon_opened:
		open_email()
	else:
		calendar_panel.visible = false
		open_email()

func open_email():
	if email_queue.size():
		example_email_label.text = email_queue[0][1]
		email_input.grab_focus()
		email_opened = true
		icon_opened = true
		open_close([email_input, example_email, close_email, send], true)
	else:
		icon_opened = false
		no_emails_panel.modulate.a = 1
		no_emails_panel.visible = true
		await get_tree().create_timer(1).timeout
		var tween = get_tree().create_tween()
		tween.tween_property(no_emails_panel, "modulate:a", 0, 1)

func _on_close_email_pressed() -> void:
	email_opened = false
	icon_opened = false
	open_close([email_input, example_email, close_email, send], false)

func _on_send_pressed() -> void:
	send_email()

func _on_calendar_icon_clicked() -> void:
	if !icon_opened:
		open_calendar()
	else:
		open_close([email_input, example_email, close_email, send], false)
		open_calendar()

func open_calendar():
		if meeting_queue.size():
			icon_opened = true
			calendar_panel.visible = true
		else:
			icon_opened = false
			no_meetings_panel.modulate.a = 1
			no_meetings_panel.visible = true
			await get_tree().create_timer(1).timeout
			var tween = get_tree().create_tween()
			tween.tween_property(no_meetings_panel, "modulate:a", 0, 1)

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
	#attendee_button_pressed()
	_on_contact_list_item_activated(contact_list.get_selected_items()[0])

func _on_add_attendee_2_pressed() -> void:
	#attendee_button_pressed()
	_on_contact_list_item_activated(contact_list.get_selected_items()[0])

func _on_add_attendee_3_pressed() -> void:
	#attendee_button_pressed()
	_on_contact_list_item_activated(contact_list.get_selected_items()[0])

#func attendee_button_pressed():
	#cur_attendee_button.text = contact_list.get_item_text(contact_list.get_selected_items()[0])
	#open_close([contact_list, contact_search, search_label], true)

func _on_contact_list_item_selected(index: int) -> void:
	cur_attendee_button.disabled = false
	#cur_attendee_button.text = contact_list.get_item_text(index)

func _on_contact_list_item_activated(index: int) -> void:
	cur_attendee_button.text = contact_list.get_item_text(index)
	cur_attendee_button.disabled = true
	if cur_attendee_button_index < 2:
		cur_attendee_button_index += 1
		cur_attendee_button = attendee_buttons[cur_attendee_button_index]
		cur_attendee_button.visible = true
	contact_search.text = ''
	_on_contact_search_text_changed('')
	#open_close([contact_list, contact_search, search_label], false)

func _on_add_to_calendar_pressed() -> void:
	var minute = minute_picker.value
	var cur_attendees := []
	var opt_zero: String = '0' if minute < 10 else ''
	minute = opt_zero + str(minute)
	for i in attendee_buttons:
		if i.text != 'Add':
			cur_attendees.append(i.text)
	
	var cur_meeting = [cur_attendees, month_picker.text, str(day_picker.value), str(hour_picker.value), str(minute)]
	var normalized_meeting_queue = meeting_queue.map(func(item): return item.map(func(sub): return str(sub)))
	var normalized_cur_meeting = cur_meeting.map(func(sub): return str(sub))
	
	if normalized_cur_meeting in normalized_meeting_queue:
		meeting_queue.remove_at(normalized_meeting_queue.find(normalized_cur_meeting))
		meeting_count_label.text = str(meeting_queue.size())
		if !meeting_queue.size():
			calendar_panel.visible = false
			icon_opened = false
	else:
		game_over()

func reset_calendar():
	for i in attendee_buttons:
		i.text = 'Add'
		i.disabled = true
	cur_attendee_button_index = 0
	cur_attendee_button = add_attendee_1
	add_attendee_1.visible = true
	open_close([add_attendee_2, add_attendee_3], false)

func _on_continue_call_pressed() -> void:
	text_scroll.play()
	call_finished = false
	continue_call.visible = false
	if cur_reason == 'Schedule Meeting':
		meeting_attendees = []
		for i in randi_range(1, 3):
			meeting_attendees.append(company_employee[rand][i + 1])
		var month = randi_range(0, 11)
		var minute = randi_range(1, 59)
		var opt_zero: String = '0' if minute < 10 else ''
		minute = opt_zero + str(minute)
		meeting_queue.append([meeting_attendees, calendar_list[month][0], randi_range(1, calendar_list[month][1]) , str(randi_range(0, 23)),  minute])
		meeting_count_label.text = str(meeting_queue.size())
		var all_attendees = ''
		for i in meeting_attendees:
			all_attendees += '\n' + i
		phone_vbox.visible = false
		meeting_vbox.visible = true
		typing = true
		call_typewriter(meeting_attendees_label, 'Attendees: ' + all_attendees)
		await typing_finished
		call_typewriter(meeting_date_label, 'Date:\n' + meeting_queue[0][1] + ' ' + str(meeting_queue[0][2]) + '\n')
		await typing_finished
		call_typewriter(meeting_time_label, 'Time:\n' + meeting_queue[0][3] + ':' + meeting_queue[0][4])
		text_scroll.stop()
		call_finished = true
		typing = false
		hang_up.visible = true

func format_time(value: int, node: SpinBox):
	var opt_zero: String = '0' if value < 10 else ''
	node.prefix = opt_zero

func _on_minute_picker_value_changed(value: float) -> void:
	format_time(value, minute_picker)

func _on_minute_picker_focus_exited() -> void:
	format_time(minute_picker.value, minute_picker)
	
func _on_hour_picker_value_changed(value: float) -> void:
	format_time(value, hour_picker)

func _on_hour_picker_focus_exited() -> void:
	format_time(hour_picker.value, hour_picker)

func _on_close_calendar_pressed() -> void:
	icon_opened = false
	calendar_panel.visible = false

func _on_reset_calendar_pressed() -> void:
	reset_calendar()

func reset_text(labels: Array[Label]):
	for label in labels:
		label.text = ''

func _on_hang_up_pressed() -> void:
	reset_text([phone_caller_label, phone_company_label, phone_reason_label, meeting_attendees_label, meeting_date_label, meeting_time_label])
	phone_vbox.visible = true
	meeting_vbox.visible = false
	call_finished = false
	hang_up.visible = false
	hang_up_status = true
	_on_phone_clicked()
