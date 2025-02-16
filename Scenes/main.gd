extends Node2D

@onready var desktop: Node2D = $Desktop
@onready var label: Label = $ExampleEmail/Panel/Label
@onready var email_input: email_class = $EmailInput
@onready var example_email: Control = $ExampleEmail
@onready var taskbar: HBoxContainer = $Taskbar
@onready var email_task: Control = $Taskbar/EmailTask

var email_opened := false
var task_queue := []
var new_email: String
var email_responses: Dictionary = {
	1: "I'd explain why this won't work, but I have a feeling you're not big on listening to reason.",
	2: "It's cute that you think this is my problem.",
	3: "I appreciate your enthusiasm, even if the facts don't quite agree with you.",
	4: "I see we're embracing creativity over accuracy today.",
	5: "Fascinating request - I'll be sure to add it to my ever-growing list of miracles to perform.",
	6: "I admire your confidence in sending this.",
	7: "Let me take a deep breath before I begin.",
	8: "It's always refreshing to see such… unique interpretations of reality.",
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
	22: "I can already tell this is going to be a 'take a deep breath before responding’ kind of email.",
	23: "It’s almost impressive how many errors you fit into one request.",
	24: "If you keep moving the goalposts like this, we might as well play a different game.",
	25: "I see we’re just saying things now with no regard for reality.",
	26: "Oh, fantastic. Another episode of 'I have no idea what I’m doing, so please fix it for me.’",
	27: "I appreciate your enthusiasm, even if your logic is wildly flawed.",
	28: "Let me just consult my crystal ball since no actual details were included.",
	29: "Your confidence in being incorrect is truly something to behold.",
	30: "I’d love to help, but unfortunately, I value my sanity.",
	31: "Bold move sending this email like I wouldn’t notice the nonsense in it.",
	32: "I assume this was sent for comedic effect because otherwise, I’d be concerned.",
	33: "Oh good, an opportunity to practice patience I didn’t ask for.",
	34: "Let me know when you’ve completed your warm-up round of bad ideas.",
	35: "You might be onto something here - though I’d recommend getting off of it immediately.",
	36: "This is the kind of email that makes me reconsider my life choices.",
	37: "I’d say 'nice try,' but that would imply an attempt at correctness was made.",
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

func _ready() -> void:
	label.text = choose_email()
	task_queue.append([email_task, label.text])

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed('ui_accept') and email_opened:
		if email_input.text == label.text:
			_on_desktop_clicked()

			task_queue[0][0].queue_free()
			task_queue.pop_front()
			email_input.text = ''
			if task_queue.size():
				label.text = task_queue[0][1]
		else:
			print('Error!')
			_on_desktop_clicked()

func choose_email() -> String:
	return email_responses[randi_range(1, 60)]

func _on_email_input_text_changed() -> void:
	var new_email_text: String = email_input.text
	if new_email_text.length() > label.text.length():
		email_input.text = email_input.cur_email_text
		email_input.set_caret_line(email_input.cursor_line)
		email_input.set_caret_column(email_input.cursor_column)
	
	email_input.cur_email_text = email_input.text
	email_input.cursor_line = email_input.get_caret_line()
	email_input.cursor_column = email_input.get_caret_column()
	
	for i in email_input.text.length():
		if email_input.text[i] != label.text[i]:
			email_input.add_theme_color_override('font_color', Color(1, 0, 0))
			break
		else:
			email_input.add_theme_color_override('font_color', Color(1, 1, 1))

func _on_desktop_clicked() -> void:
	if task_queue.size():
		email_opened = !email_opened
		email_input.visible = !email_input.visible
		example_email.visible = !example_email.visible

func _on_new_email_pressed() -> void:
	var email_task_scene = preload('res://Scenes/email_task.tscn')
	var new_email_task = email_task_scene.instantiate()
	task_queue.append([new_email_task, choose_email()])
	
	taskbar.add_child(new_email_task)
