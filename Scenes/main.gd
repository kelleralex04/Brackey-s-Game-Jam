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
@onready var door_shutting: AudioStreamPlayer = $BossSpeech/DoorShutting
@onready var pointer_1: TextureRect = $Pointer1
@onready var pointer_2: TextureRect = $Pointer2
@onready var tutorial_panel_1: Panel = $TutorialPanel1
@onready var tutorial_panel_2: Panel = $TutorialPanel2
@onready var pointer_3: TextureRect = $Pointer3
@onready var email_to: LineEdit = $Screen/EmailTo
@onready var email_recipient_panel: Panel = $Screen/EmailRecipientPanel
@onready var email_recipient_label: Label = $Screen/EmailRecipientPanel/EmailRecipientLabel
@onready var boom: AudioStreamPlayer = $Boom

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
var timer_length: int
var email_to_cursor_line := 0
var email_to_cursor_column := 0

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
	50: "Absolutely, I'll get on that right away... unless my pet rock needs emotional support again.",
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
var event_tracker := [
	['Ah, Mr. Hawthorne! It\'s so nice to meet you, my name\'s...', 0],
	['Yeah that\'s great kid. You got any questions before you get started?', 1],
	['I guess I\'m just a bit confused... What is it we do here exactly?', 0],
	['We\'re a consulting company that helps other consulting companies find innovative technical solutions to real world', 1],
	['problems in the Web3 and Web4 spaces while providing SaaS and synergy across all areas of modern day business.', 1],
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
	'email',
	['So how was your first day?', 1],
	['Great, although I\'ve gotta say these emails are still pretty mean spirited.', 0],
	['Ah, I\'m sure it\'s fine. Now listen.', 1],
	['Unfortunately we had to let go of our other assistant today so you\'ll be picking up her duties starting tomorrow.', 1],
	['Oh no, that\'s terrible. What was she fired for?', 0],
	['We just felt that our goals weren\'t aligning for optimal officeplace workflow.', 1],
	['Don\'t worry though, your job is completely safe... as long as you continue the good work that is.', 1],
	['Well OK, I guess I\'m glad to have the opportunity to pick up some more responsibilies.', 0],
	['Any chance these extra duties come with a pay raise?', 0],
	['Oh certainly, once you\'ve proven you\'re up to the task we can definitely talk money.', 1],
	['There may even be a promotion coming your way!', 1],
	['Well great! I\'ll be in extra early tomorrow to learn about my new tasks.', 0],
	['That\'s the spirit kid!', 1],
	'next day',
	['Oh hey boss. Not gonna lie, I didn\'t get much sleep last night. There was this cat outside my window and...', 0],
	['Yeah that\'s great bud, now listen. I\'m jetting off to Bermuda at the end of the day so I need to make sure',1],
	['we get today\'s work done quickly, capisce?', 1],
	['Yes sir, understood.', 0],
	['Good, now get on the phone and start setting up some meetings. And make sure you don\'t keep anyone on the line for too long.', 1],
	['Too long on the phone means angry clients and angry clients means less shareholder value.', 1],
	['We wouldn\'t want that now, would we?', 1],
	['... Um, no I guess?', 0],
	['Answer more quickly next time, I don\'t pay you to sit around thinking about obvious answers all day.', 1],
	['You got it boss.', 0],
	'phone',
	['How\'s my favorite assistant doing?', 1],
	['Good boss, got all your meetings scheduled just like you asked.', 0],
	['Although you guys sure do meet at odd times, I think that first meeting was at 4AM on Christmas.', 0],
	['Look kid, there\'s never a bad time to be making money. Remember that and you\'ll go far in this business.', 1],
	['You got it boss. So about that promotion we were talking about yesterday...', 0],
	['No time to chat kid, I\'ve gotta be wheels up in 30.', 1],
	['Sure thing boss. I\'ll get back to you about it tomorrow.', 0],
	'next day',
	#['Hey kid, ready for another great day?', 1],
	['Oh, hey boss. To be honest, I think I might be coming down with something.', 0],
	['Ah, bad case of the Mondays huh?', 1],
	['Well no, and also it\'s Wednesday...', 0],
	['Look kid, I don\'t pay you to tell me what day it is, I pay you to make phone calls and send emails.', 1],
	['And by the way, you\'re gonna have to do both today, we fired another assistant.', 1],
	['Oh gosh, OK, I guess I can handle that. While I have you though can we just talk real quick about some kind of raise?', 0],
	['Get your work done today and I promise we\'ll have a talk at the end of the day. Now get to it, time is money kid!', 1],
	'day 3',
	['Hey there, you done with all your work for the day?', 1],
	['Oh, yes sir just finished up.', 0],
	['Excellent, great job. You\'ve done some really swell work around here.', 1],
	['Unfortunately we are going to have to let you go.', 1],
	['... Are you kidding me?', 0],
	['I\'m afraid not. Although we made record profits this year, there\'s just no room in the budget for a personal assistant.', 1],
	['Gotta keep those shareholders happy.', 1],
	['Anyways, keep your head up. I\'m sure you\'ll land on your feet.', 1],
	['Please just don\'t list me as a reference though.', 1],
	['I\'m going to be on my private island for the rest of the year and I don\'t want to be bothered.', 1],
	'end'
]
@onready var event_index := 0
@onready var speakers = [player_speech_label, boss_speech_label]
@onready var tutorial_index := 0
@onready var day = 1
@onready var day_changing := false
@onready var skip_tutorial := false
@onready var anger_speed := 0.0
@onready var first := true
@onready var second := true
@onready var third := true
@onready var fourth := true
#@onready var tutorial := false

#Other tasks: order lunch, hand out lunch

func _ready() -> void:
	timer.wait_time = int(Global.selected[0]) * 60
	#blocker.visible = true
	#blocker.color = Color(0, 0, 0, 0)
	#typewriter_finished = true
	#phone_tutorial()
	boom.play()
	timer_length = 2
	open_close([blocker, day_label], true)
	var line_edit = hour_picker.get_line_edit()
	line_edit.context_menu_enabled = false
	line_edit = minute_picker.get_line_edit()
	line_edit.context_menu_enabled = false
	line_edit = day_picker.get_line_edit()
	line_edit.context_menu_enabled = false
	
	typing_speed = 0.05
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
	tween1.tween_property(day_label, "modulate:a", 0, 4)
	await get_tree().create_timer(timer_length).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(blocker, "modulate:a", 0, 2)
	await get_tree().create_timer(timer_length).timeout
	day_label.visible = false
	boss_speech.visible = true
	skip_typewriter = false
	boss_speak('Hey there, I had heard we had a new hire! Hope you\'re enjoying your first day at DigiTech Innovative Solutions Incorporated.')

func _process(delta: float) -> void:
	var remaining_time = timer.time_left
	minutes = int(remaining_time) / 60
	seconds = int(remaining_time) % 60
	milliseconds = int((remaining_time - int(remaining_time)) * 100)
	time_left.text = str(minutes) + ":" + str(seconds).pad_zeros(2) + ":" + str(milliseconds).pad_zeros(2)
	
	$AngerMeter.value += anger_speed
	
	if $AngerMeter.value >= 100:
		$AngerMeter.visible = false
		anger_speed = 0
		$AngerMeter.value = 0
		game_over()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed('ui_accept') and email_opened:
		send_email()
	
	if Input.is_action_just_pressed('ui_select') and blocker.visible:
		#phone_tutorial()
		if typewriter_finished == false:
			skip_typewriter = true
		else:
			if typeof(event_tracker[event_index]) == 28:
				skip_typewriter = false
				next_dialogue(event_index)
			elif event_tracker[event_index] == 'test':
				open_close([blocker, day_label], false)
				open_close([taskbar_panel, time_left, $TimerPanel, $TaskbarPanel/MeetingTask, $TaskbarPanel/MeetingCountLabel], true)
				add_meeting()
			elif event_tracker[event_index] == 'next day' and !day_changing:
				tutorial_index = 0
				next_day()
			elif day_changing:
				pass
			elif event_tracker[event_index] == 'phone':
				if second:
					day_changing = true
					var tween1 = get_tree().create_tween()
					tween1.tween_property(blocker, "modulate:a", 1, 1)
					await get_tree().create_timer(1).timeout
					second = false
				phone_tutorial()
			elif event_tracker[event_index] == 'day 3' and third:
				day_changing = true
				var tween1 = get_tree().create_tween()
				tween1.tween_property(blocker, "modulate:a", 1, 1)
				await get_tree().create_timer(1).timeout
				for i in 3:
					_on_new_email_pressed()
					add_meeting()
				door_shutting.play()
				open_close([boss, boss_speech, boss_speech_tick, player_speech, player_speech_tick], false)
				open_close([boss_2], true)
				await get_tree().create_timer(1).timeout
				var tween2 = get_tree().create_tween()
				tween2.tween_property(blocker, "modulate:a", 0, 1)
				await get_tree().create_timer(1).timeout
				open_close([$StartTimer], true)
				third = false
				day_changing = false
			elif skip_tutorial:
				if !email_queue.size():
					for i in 1:
						_on_new_email_pressed()
					open_close([boss_2, taskbar_panel, $TaskbarPanel/MeetingTask, $TaskbarPanel/MeetingCountLabel, $StartTimer, $TimerPanel], true)
					open_close([boss, boss_speech, boss_speech_tick, player_speech, player_speech_tick], false)
			elif event_tracker[event_index] == 'email':
				if first:
					day_changing = true
					var tween1 = get_tree().create_tween()
					tween1.tween_property(blocker, "modulate:a", 1, 1)
					await get_tree().create_timer(1).timeout
					first = false
				email_tutorial()
			elif event_tracker[event_index] == 'end':
				$StartTimer.visible = false
				$Thanks.visible = true
				$PlayAgain.visible = true
				var tween1 = get_tree().create_tween()
				tween1.tween_property(blocker, "modulate:a", 1, 4)
				var tween2 = get_tree().create_tween()
				tween2.tween_property($Thanks, "modulate:a", 1, 4)
				var tween3 = get_tree().create_tween()
				tween3.tween_property($PlayAgain, "modulate:a", 1, 4)
				await get_tree().create_timer(4).timeout
			else:
				boss_2.visible = true
				open_close([blocker, boss, boss_speech, boss_speech_tick, player_speech, player_speech_tick], false)

func next_day():
	day += 1
	day_changing = true
	var tween1 = get_tree().create_tween()
	tween1.tween_property(blocker, "modulate:a", 1, 2)
	await get_tree().create_timer(timer_length).timeout
	boom.play()
	day_label.text = 'Day ' + str(day)
	day_label.visible = true
	day_label.modulate = Color(1, 1, 1, 1)
	boss_speech.visible = false
	player_speech.visible = false
	if day == 2:
		john_office.visible = false
		$JohnOffice2.visible = true
	elif day == 3:
		$JohnOffice2.visible = false
		$JohnOffice3.visible = true
	#open_close([boss, boss_speech], false)
	#boss_2.visible = true
	await get_tree().create_timer(timer_length).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(blocker, "modulate:a", 0, 2)
	var tween3 = get_tree().create_tween()
	tween3.tween_property(day_label, "modulate:a", 0, 2)
	await get_tree().create_timer(timer_length).timeout
	event_index += 1
	day_changing = false
	boss_speech.visible = true
	skip_typewriter = false
	boss_speech_label.text = ''
	player_speech_label.text = ''
	boss_speak('Alright who\'s ready for another great day!')

func email_tutorial():
	if tutorial_index == 0:
		for i in 3:
			_on_new_email_pressed()
		open_close([boss, boss_speech, boss_speech_tick, player_speech, player_speech_tick], false)
		door_shutting.play()
		open_close([pointer_1, boss_2, taskbar_panel, tutorial_panel_1], true)
		await get_tree().create_timer(1).timeout
		var tween1 = get_tree().create_tween()
		tween1.tween_property(blocker, "modulate:a", 0, 1)
		await get_tree().create_timer(1).timeout
		day_changing = false
		tutorial_index += 1
	elif tutorial_index == 1:
		open_close([pointer_1, tutorial_panel_1], false)
		open_close([pointer_2, tutorial_panel_2], true)
		tutorial_index += 1
	elif tutorial_index == 2:
		open_close([pointer_2, tutorial_panel_2], false)
		_on_desktop_clicked()
		pointer_3.visible = true
		tutorial_index += 1
	elif tutorial_index == 3:
		pointer_3.visible = false
		_on_email_icon_clicked()
		email_to.release_focus()
		$TutorialPanel3.visible = true
		tutorial_index += 1
	elif tutorial_index == 4:
		$TutorialPanel3/TutorialLabel3.text = 'Make sure you copy everything exactly. This is an important week for Mr. Hawthorne so Nothing Can Go Wrong!'
		tutorial_index += 1
	elif tutorial_index == 5:
		$TutorialPanel3.visible = false
		_on_close_email_pressed()
		_on_close_screen_pressed()
		open_close([$TutorialPanel4, $Pointer4, $TimerPanel], true)
		tutorial_index += 1
	elif tutorial_index == 6:
		open_close([$TutorialPanel4, $Pointer4], false)
		open_close([$Pointer5, $TutorialPanel5, $StartTimer], true)
		tutorial_index += 1
	elif tutorial_index == 7:
		open_close([$Pointer5, $TutorialPanel5], false)
		#blocker.visible = false

func phone_tutorial():
	if tutorial_index == 0:
		open_close([boss, boss_speech, boss_speech_tick, player_speech, player_speech_tick], false)
		door_shutting.play()
		open_close([boss_2, $TaskbarPanel/MeetingTask, $TaskbarPanel/MeetingCountLabel, $TutorialPanel6, $Pointer6], true)
		for i in 3:
			#_on_new_email_pressed()
			add_meeting()
		await get_tree().create_timer(1).timeout
		var tween1 = get_tree().create_tween()
		tween1.tween_property(blocker, "modulate:a", 0, 1)
		await get_tree().create_timer(1).timeout
		day_changing = false
		tutorial_index += 1
	elif tutorial_index == 1:
		open_close([$TutorialPanel6, $Pointer6], false)
		open_close([$TutorialPanel7, $Pointer7], true)
		tutorial_index += 1
	elif tutorial_index == 2:
		open_close([$TutorialPanel7, $Pointer7], false)
		open_close([$PhonePanel2, $AngerMeter, $AngryFace, $TutorialPanel9], true)
		tutorial_index += 1
	elif tutorial_index == 3:
		open_close([$PhonePanel2, $AngerMeter, $AngryFace, $TutorialPanel9], false)
		_on_desktop_clicked()
		open_close([$Pointer8], true)
		tutorial_index += 1
	elif tutorial_index == 4:
		open_close([$Pointer8], false)
		_on_calendar_icon_clicked()
		$TutorialPanel8.visible = true
		tutorial_index += 1
	elif tutorial_index == 5:
		$TutorialPanel8.visible = false
		_on_close_calendar_pressed()
		_on_close_screen_pressed()
		$StartTimer.visible = true
		tutorial_index += 1

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
	var speaker = speakers[event_tracker[index][1]]
	speaker.text = ''
	if speaker == player_speech_label:
		open_close([boss_speech, boss_speech_tick], false)
		player_speech.visible = true
		player_speak(event_tracker[index][0])
	else:
		open_close([player_speech, player_speech_tick], false)
		boss_speech.visible = true
		boss_speak(event_tracker[index][0])
	event_index += 1

func send_email():
	if !blocker.visible:
		if email_input.text == example_email_label.text and email_to.text == email_recipient_label.text:
			#_on_desktop_clicked()
			#email_queue[0][0].queue_free()
			email_queue.pop_front()
			email_count_label.text = str(email_queue.size())
			var temp_timer = Timer.new()
			await get_tree().create_timer(0.01).timeout
			email_input.text = ''
			email_to.text = ''
			if email_queue.size():
				example_email_label.text = email_queue[0][1][0]
				email_recipient_label.text = email_queue[0][1][1]
				email_to.max_length = email_recipient_label.text.length()
				email_to.grab_focus()
			else:
				icon_opened = false
				open_close([email_input, example_email, close_email, send, email_to, email_recipient_panel], false)
				day_finished()
		else:
			_on_desktop_clicked()
			game_over()

func choose_email() -> Array:
	return [email_responses[randi_range(1, 60)], all_names[randi_range(0, 149)]]
	#return ['a', 'a']

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


func _on_email_to_text_changed(new_text: String) -> void:
	for i in range(new_text.length()):
		if new_text[i] != email_recipient_label.text[i]:
			email_to.add_theme_color_override('font_color', Color(1, 0, 0))
			break
		else:
			email_to.add_theme_color_override('font_color', Color(1, 1, 1))


func _on_desktop_clicked() -> void:
	#if email_queue.size():
		#if !open_panel or open_panel and desktop_opened:
			#open_panel = !open_panel
	desktop_opened = true
	screen.visible = true

func _on_phone_clicked() -> void:
	if meeting_queue.size():
		open_close([$AngerMeter, $AngryFace], true)
		anger_speed = 0.05
		skip_typewriter = false
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
	else:
		pass

func phone_call():
	typing = true
	_on_continue_call_pressed()
	#new_call()
	#text_scroll.play()
	#call_typewriter(phone_caller_label, 'Caller:\n' + cur_caller)
	#await typing_finished
	#call_typewriter(phone_company_label, 'Company:\n' + cur_company)
	#await typing_finished
	#call_typewriter(phone_reason_label, 'Reason:\n' + cur_reason)
	#await typing_finished
	#text_scroll.stop()
	#call_finished = true
	#continue_call.visible = true
	#typing = false

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
	if skip_typewriter and typewriter_timer:
		cur_label.text = full_text
		typewriter_finished = true
		typewriter_index = 0
		if typewriter_timer:
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
	timer.set_paused(false)
	blocker.visible = false
	$StartTimer.visible = false

func _on_timer_timeout() -> void:
	game_over()

func _on_restart_pressed() -> void:
	blocker.visible = true
	game_over_panel.visible = false
	email_to.text = ''
	email_input.text = ''
	reset_calendar()
	icon_opened = false
	open_close([email_input, example_email, close_email, send, email_to, email_recipient_panel, calendar_panel], false)
	_on_close_screen_pressed()
	_on_hang_up_pressed()
	email_queue = []
	meeting_queue = []
	if day == 1:
		for i in 3:
			_on_new_email_pressed()
	elif day == 2:
		for i in 3:
			add_meeting()
	elif day == 3:
		for i in 3:
			add_meeting()
			_on_new_email_pressed()
	blocker.visible = true
	$StartTimer.visible = true

func game_over():
	send.release_focus()
	$Screen/CalendarPanel/AddToCalendar.release_focus()
	timer.set_paused(true)
	game_over_panel.visible = true

func _on_close_screen_pressed() -> void:
	desktop_opened = false
	screen.visible = false

func _on_hold_phone_pressed() -> void:
	_on_phone_clicked()
	anger_speed = 0.1

func _on_email_icon_clicked() -> void:
	if !icon_opened:
		open_email()
	else:
		calendar_panel.visible = false
		open_email()

func open_email():
	if email_queue.size():
		example_email_label.text = email_queue[0][1][0]
		email_recipient_label.text = email_queue[0][1][1]
		email_to.max_length = email_recipient_label.text.length()
		email_to.grab_focus()
		email_opened = true
		icon_opened = true
		open_close([email_input, example_email, close_email, send, email_to, email_recipient_panel], true)
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
	open_close([email_input, example_email, close_email, send, email_to, email_recipient_panel], false)

func _on_send_pressed() -> void:
	send_email()

func _on_calendar_icon_clicked() -> void:
	if !icon_opened:
		open_calendar()
	else:
		open_close([email_input, example_email, close_email, send, $Screen/EmailTo, $Screen/EmailRecipientPanel], false)
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
	if !blocker.visible:
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
			reset_calendar()
			if !meeting_queue.size():
				day_finished()
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
	month_picker.selected = -1
	day_picker.value = 1
	hour_picker.value = 0
	minute_picker.value = 0

func _on_continue_call_pressed() -> void:
	text_scroll.play()
	call_finished = false
	continue_call.visible = false
	#if cur_reason == 'Schedule Meeting':
		#meeting_attendees = []
		#for i in randi_range(1, 3):
			#meeting_attendees.append(company_employee[rand][i + 1])
		#var month = randi_range(0, 11)
		#var minute = randi_range(1, 59)
		#var opt_zero: String = '0' if minute < 10 else ''
		#minute = opt_zero + str(minute)
		#meeting_queue.append([meeting_attendees, calendar_list[month][0], randi_range(1, calendar_list[month][1]) , str(randi_range(0, 23)),  minute])
		#meeting_count_label.text = str(meeting_queue.size())
	var cur_meeting_attendees = meeting_queue[0][0]
	var all_attendees = ''
	for i in cur_meeting_attendees:
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

func add_meeting():
		rand = randi_range(0, 49)
		meeting_attendees = []
		for i in randi_range(1, 3):
			meeting_attendees.append(company_employee[rand][i + 1])
		var month = randi_range(0, 11)
		var minute = randi_range(1, 59)
		var opt_zero: String = '0' if minute < 10 else ''
		minute = opt_zero + str(minute)
		meeting_queue.append([meeting_attendees, calendar_list[month][0], randi_range(1, calendar_list[month][1]) , str(randi_range(0, 23)),  minute])
		meeting_count_label.text = str(meeting_queue.size())

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
	anger_speed = 0
	$AngerMeter.value = 0
	open_close([$AngerMeter, $AngryFace], false)
	phone_vbox.visible = true
	meeting_vbox.visible = false
	call_finished = false
	hang_up.visible = false
	#hang_up_status = true
	phone_opened = false
	phone_panel.visible = false
	#hang_up_status = false
	#_on_phone_clicked()

func day_finished():
	if !email_queue.size() and !meeting_queue.size():
		send.release_focus()
		$Screen/CalendarPanel/AddToCalendar.release_focus()
		_on_hang_up_pressed()
		skip_typewriter = false
		timer.set_paused(true)
		_on_close_screen_pressed()
		event_index += 1
		blocker.visible = true
		var tween1 = get_tree().create_tween()
		tween1.tween_property(blocker, "modulate:a", 1, 2)
		await get_tree().create_timer(2).timeout
		boss_2.visible = false
		boss.visible = true
		var tween2 = get_tree().create_tween()
		tween2.tween_property(blocker, "modulate:a", 0, 2)
		await get_tree().create_timer(2).timeout
		next_dialogue(event_index)

func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/title.tscn")
