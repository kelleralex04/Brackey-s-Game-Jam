extends TextEdit

class_name email_class

var cur_email_text := ''
var cursor_line := 0
var cursor_column := 0

#func _on_text_changed() -> void:
	#var new_email_text: String = email_input.text
	#if new_email_text.length() > main.label.text.length():
		#email_input.text = cur_email_text
		#set_caret_line(cursor_line)
		#set_caret_column(cursor_column)
	#
	#cur_email_text = email_input.text
	#cursor_line = get_caret_line()
	#cursor_column = get_caret_column()
	#
	#for i in email_input.text.length():
		#if email_input.text[i] != label.text[i]:
			#print('WRONG!')
			#break
