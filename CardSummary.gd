extends Button

var question

func set_card(title, questionText, ans):
	$text_question.text = title
	$Mouseover/MarginContainer/VBoxContainer/Label2.text = questionText
	$sprite_ans.scale = Vector2(0.09, 0.09)
	if ans == 'ans1':
		$sprite_ans.texture = load("res://assets/btn_1.png")
	elif ans == 'ans2':
		$sprite_ans.texture = load("res://assets/btn_2.png")
	elif ans == 'ans3':
		$sprite_ans.texture = load("res://assets/btn_3.png")
	elif ans == '':
		pass
	else:
		$sprite_ans.texture = load("res://assets/cursor.png")
		$sprite_ans.scale = Vector2(0.09, 0.06)
		$Mouseover/MarginContainer/VBoxContainer/Label2.text = questionText + "\n\nAnswered:\n" + ans

func set_ans(ans):
	set_card($text_question.text, $Mouseover/MarginContainer/VBoxContainer/Label2.text, ans)


func _on_ZoomButton_button_up():
	get_parent().get_parent().get_node('tutorial').visible = false
	get_parent().get_parent().get_parent().zoom_To_Card($text_question.text)


func _on_ZoomButton_mouse_entered():
	$Mouseover.visible = true
	# Move tooltip up to prevent clipping below Y axis:
	# Warning: Doesn't check clipping above y=0
	while $Mouseover/MarginContainer.rect_size.y + \
		$Mouseover/MarginContainer.rect_global_position.y > \
		get_viewport_rect().size.y - 10:
		$Mouseover/MarginContainer.rect_position.y -= 1


func _on_ZoomButton_mouse_exited():
	$Mouseover.visible = false
