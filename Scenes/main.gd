extends Node2D

@onready var desktop: Node2D = $Desktop
@onready var label: Label = $ExampleEmail/Panel/Label
@onready var email_input: email_class = $EmailInput
@onready var example_email: Control = $ExampleEmail

var email_opened := false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

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
			print('WRONG!')
			break

func _on_desktop_desktop_clicked() -> void:
	email_opened = true
	email_input.visible = !email_input.visible
	example_email.visible = !example_email.visible
	
