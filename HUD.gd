extends CanvasLayer

signal on_message_sent(message)

func _ready():
	update_code_visibility()
	$TextEdit.readonly = true

func _on_Button_pressed():
	var input = $LineEdit.get_text()
	emit_signal("on_message_sent", input)


func _on_CheckBox_toggled(button_pressed):
	update_code_visibility()
	
func update_code_visibility():
	var new_visibility = $CheckBox.is_pressed()
	$TextEdit.set_visible(new_visibility)
	
func set_text(text):
	$TextEdit.set_text(text)
