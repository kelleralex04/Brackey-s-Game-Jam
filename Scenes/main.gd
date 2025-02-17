extends Node2D

@onready var desktop: Node2D = $Desktop
@onready var label: Label = $ExampleEmail/Panel/Label
@onready var email_input: email_class = $EmailInput
@onready var example_email: Control = $ExampleEmail
@onready var taskbar: HBoxContainer = $Taskbar
@onready var email_task: Control = $Taskbar/EmailTask

var email_opened := false
var task_queue := []

func _ready() -> void:
	task_queue.append(email_task)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed('ui_accept') and email_opened:
		if email_input.text == label.text:
			_on_desktop_clicked()

			task_queue[0].queue_free()
			task_queue.pop_front()
			email_input.text = ''
			print(task_queue)
		else:
			print('Error!')
			_on_desktop_clicked()

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
	label.text = 'new text'
	
	var email_task_scene = preload('res://Scenes/email_task.tscn')
	var new_email_task = email_task_scene.instantiate()
	task_queue.append(new_email_task)
	
	taskbar.add_child(new_email_task)
	print(task_queue)
