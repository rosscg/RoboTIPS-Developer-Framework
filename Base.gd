extends Node2D

var card_scene = preload("res://CardBase.tscn")
var card_summ_scene = preload("res://CardSummary.tscn")
var active_deck
var zoomed_i = 0

# Format: [heading, question_text, answer, isTextInput]
var deck_business = [
	['BusinessQ1', 'Question 1 text goes here', '', true],
	['BusinessQ2', 'Question 2 text goes here', '', false],
	['BusinessQ3', 'Question 3 text goes here', '', true],
	['BusinessQ4', 'Question 4 text goes here', '', false],
	['BusinessQ5', 'Question 5 text goes here', '', true]
]
var deck_legal = [
	['LegalQuestion1', 'Question text goes here', '', false],
	['LegalQuestion2', 'Question text goes here', '', true],
	['LegalQuestion3', 'Question text goes here', '', false],
	['LegalQuestion4', 'Question text goes here', '', true],
	['LegalQuestion5', 'Question text goes here', '', false]
]
var deck_hardware = [
	['HardwareQ2', 'Question text goes here', '', true],
	['HardwareQ1', 'Question text goes here', '', false],
	['HardwareQ3', 'Question text goes here', '', true],
	['HardwareQ4', 'Question text goes here', '', false],
	['HardwareQ5', 'Question text goes here', '', true],
	['HardwareQ6', 'Question text goes here', '', false],
	['HardwareQ7', 'Question text goes here', '', true],
	['HardwareQ8', 'Question text goes here', '', false],
	['HardwareQ9', 'Question text goes here', '', true],
	['HardwareQ10', 'Question text goes here', '', false],
	['HardwareQ11', 'Question text goes here', '', true],
	['HardwareQ12', 'Question text goes here', '', false],
	['HardwareQ13', 'Question text goes here', '', true],
	['HardwareQ14', 'Question text goes here', '', false],
	['HardwareQ15', 'Question text goes here', '', true]
]
var deck_software = [
	['SoftwareQ1', 'Extra text explaining the question in detail', '', false],
	['SoftwareQ2', 'Extra text explaining the question in detail', '', true],
	['SoftwareQ3', 'Extra text explaining the question in detail', '', false],
	['SoftwareQ4', 'Extra text explaining the question in detail', '', true],
	['SoftwareQ5', 'Extra text explaining the question in detail', '', false],
	['SoftwareQ6', 'Extra text explaining the question in detail', '', true],
	['SoftwareQ7', 'Extra text', '', false],
	['SoftwareQ8', 'Extra text', '', true],
	['SoftwareQ9', 'Extra text', '', false],
	['SoftwareQ10', 'Extra text', '', true],
	['SoftwareQ11', 'Extra text', '', false],
	['SoftwareQ12', 'Extra text', '', true],
	['SoftwareQ13', 'Extra text', '', false],
	['SoftwareQ14', 'Extra text', '', true],
	['SoftwareQ15', 'Extra text', '', false],
	['SoftwareQ16', 'Extra text', '', true],
	['SoftwareQ17', 'Extra text', '', false]
]



func _ready():
	$HomeScene.visible = true
	$CardScene.visible = false
	$SummaryScene.visible = false
	# Prepare Zoom screen:
	$SummaryScene/CardZoom/CardZoomed/CardBack.visible = false
	$SummaryScene/CardZoom/CardZoomed/VBoxContainer/ButtonBar/Button1.disabled = true
	$SummaryScene/CardZoom/CardZoomed/VBoxContainer/ButtonBar/Button2.disabled = true
	$SummaryScene/CardZoom/CardZoomed/VBoxContainer/ButtonBar/Button3.disabled = true
	$SummaryScene/CardZoom/CardZoomed/VBoxContainer/TextBar2/TextEdit.readonly = true
	$SummaryScene/CardZoom/CardZoomed/VBoxContainer/ButtonBar2/ButtonText.visible = false

func start_deal(deck_type):
	$CardScene/SpriteBusiness.visible = false
	$CardScene/SpriteLegal.visible = false
	$CardScene/SpriteHardware.visible = false
	$CardScene/SpriteSoftware.visible = false
	$CardScene.visible = true
	var deck
	if deck_type == "business":
		deck = deck_business
		$CardScene/text_title.text = "Business"
		$SummaryScene/deck_label.text = "Business"
		$CardScene/SpriteBusiness.visible = true
	elif deck_type == "legal":
		deck = deck_legal
		$CardScene/text_title.text = "Legal"
		$SummaryScene/deck_label.text = "Legal"
		$CardScene/SpriteLegal.visible = true
	elif deck_type == "hardware":
		deck = deck_hardware
		$CardScene/text_title.text = "Hardware"
		$SummaryScene/deck_label.text = "Hardware"
		$CardScene/SpriteHardware.visible = true
	elif deck_type == "software":
		deck = deck_software
		$CardScene/text_title.text = "Software"
		$SummaryScene/deck_label.text = "Software"
		$CardScene/SpriteSoftware.visible = true
	else:
		print("error: missing deck type")
	active_deck = deck
	zoomed_i = 0
	deal_deck(active_deck)


func card_answer(name, ans):
	for card in active_deck:
		if card[0] == name:
			card[2] = ans
	for card in $SummaryScene/summ_deck.get_children():
		if card.question == name:
			card.set_ans(ans)
	update_deck_counter()
	mark_deck_done()


func mark_deck_done():
	var deck_done = true
	for card in deck_business:
		if card[2] == "":
			deck_done = false
			break
	$HomeScene/Decks/label_1/deck_done.visible = deck_done
	deck_done = true
	for card in deck_legal:
		if card[2] == "":
			deck_done = false
			break
	$HomeScene/Decks/label_2/deck_done.visible = deck_done
	deck_done = true
	for card in deck_hardware:
		if card[2] == "":
			deck_done = false
			break
	$HomeScene/Decks/label_3/deck_done.visible = deck_done
	deck_done = true
	for card in deck_software:
		if card[2] == "":
			deck_done = false
			break
	$HomeScene/Decks/label_4/deck_done.visible = deck_done
	
	
func deal_deck(deck):
	update_deck_counter()
	var summ_pos = $SummaryScene/pos_summ.position
	for vals in deck:
		var card_summ = card_summ_scene.instance()
		card_summ.rect_position = summ_pos
		summ_pos.y += card_summ.rect_size.y * 1.5
#		if summ_pos.y > get_viewport_rect().size.y - (2*card_summ.rect_size.y):
		if summ_pos.y > 600 - (2*card_summ.rect_size.y):
			summ_pos.y = $SummaryScene/pos_summ.position.y
			summ_pos.x += card_summ.rect_size.x * 1.5
		card_summ.set_card(vals[0], vals[1], vals[2])
		card_summ.question = vals[0]
		$SummaryScene/summ_deck.add_child(card_summ)
	
	deck.invert()
	for vals in deck:
		if vals[2] != "":
			continue
		var card = card_scene.instance()
		card.rect_scale /= 2
		card.rect_position = $CardScene/pos_deck.position
		card.set_card(vals[0], vals[1], vals[3])
		card.name = vals[0]
		#card.get_node("CardBack/BtnDraw").disabled = true
		$CardScene/draw_deck.add_child(card)
	deck.invert()


func update_deck_counter():
	var tot = len(active_deck)
	var done = 0
	for c in active_deck:
		if c[2] != "":
			done += 1
	$CardScene/ProgressBar.value = 0 + done*100/len(active_deck)
	$CardScene/text_question_no.text = "Answered " + str(done) + " / " + str(tot)
	

func toggle_deck_draw():
	for node in $CardScene/draw_deck.get_children():
		node.get_node("CardBack/BtnDraw").disabled = not node.get_node("CardBack/BtnDraw").disabled


func _on_Button_button_up():
	for card in $CardScene/draw_deck.get_children():
		card.queue_free()
	for card in $SummaryScene/summ_deck.get_children():
		card.queue_free()
	$HomeScene.visible = true
	$CardScene.visible = false


func _on_Summary_Button_button_up():
	$SummaryScene.visible = true
	$CardScene.visible = false


func _on_Summ_Back_Button_button_up():
	$SummaryScene.visible = false
	$CardScene.visible = true


func _on_BackButton_button_up():
	$SummaryScene/CardZoom.visible = false
		

func view_Zoomed():
	$SummaryScene/CardZoom.visible = true
	
	if not active_deck:
		$SummaryScene/CardZoom.visible = false
		print('no active deck')
		return
	# count answered cards:
	var n = 0
	for c in active_deck:
		if not c[2] == "":
			n += 1
	if n == 0:
		$SummaryScene/CardZoom.visible = false
		print('none answered')
		return

	# Cycle until card with answer:
	while zoomed_i < len(active_deck) and active_deck[zoomed_i][2] == "":
		zoomed_i += 1
	if zoomed_i >= len(active_deck):
		zoomed_i = 0

	$SummaryScene/CardZoom/CardZoomed.set_card(active_deck[zoomed_i][0], \
		active_deck[zoomed_i][1], active_deck[zoomed_i][3])
	
	# Is open text card
	if active_deck[zoomed_i][3]:
		$SummaryScene/CardZoom/CardZoomed/VBoxContainer/TextBar2/TextEdit.text = active_deck[zoomed_i][2]
		pass
	else: # Multichoice
		$SummaryScene/CardZoom/CardZoomed/VBoxContainer/ButtonBar/Button1.modulate.a = 0
		$SummaryScene/CardZoom/CardZoomed/VBoxContainer/ButtonBar/Button2.modulate.a = 0
		$SummaryScene/CardZoom/CardZoomed/VBoxContainer/ButtonBar/Button3.modulate.a = 0
		if active_deck[zoomed_i][2] == 'ans1':
			$SummaryScene/CardZoom/CardZoomed/VBoxContainer/ButtonBar/Button1.modulate.a = 1
		elif active_deck[zoomed_i][2] == 'ans2':
			$SummaryScene/CardZoom/CardZoomed/VBoxContainer/ButtonBar/Button2.modulate.a = 1
		elif active_deck[zoomed_i][2] == 'ans3':
			$SummaryScene/CardZoom/CardZoomed/VBoxContainer/ButtonBar/Button3.modulate.a = 1


# Matches card to question text
# Assumes unique card titles per deck
func zoom_To_Card(text):
	for i in range(len(active_deck)):
		if active_deck[i][0] == text and active_deck[i][2] != "":
			zoomed_i = i
			view_Zoomed()
			break
	
	
func _on_NextCardButton_button_up():
	zoomed_i += 1
	view_Zoomed()

func _on_LastCardButton_button_up():
	if zoomed_i == 0:
		zoomed_i = len(active_deck) - 1
		# Loops around to last answered card in array
		while active_deck[zoomed_i][2] == "":
			zoomed_i -= 1
	zoomed_i -= 1
	view_Zoomed()
