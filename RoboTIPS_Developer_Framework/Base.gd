extends Node2D

var card_scene = preload("res://CardBase.tscn")
var card_summ_scene = preload("res://CardSummary.tscn")
var active_deck
var zoomed_i = 0
var SURVEY_URL = "https://forms.office.com/e/ns7Utn7iAw"

# Format: [heading, question_text, answer, isTextInput]
var deck_general = [
	['Human network 1', 'Who are the human users?', '', true],
	['Human network 2', 'Who are the human users’ human network - those who, by virtue of being near the human, will 	also be near the robot? ', '', true],
	['Human network 3', 'How will the robot interact with the human network?', '', true],
	['Human network 4', 'Are there members of the human network that need particular accommodations? (e.g., child language filter?)', '', true],
	['Human network 5', 'Could use of the robot positively alter the user or their human network’s behaviour?', '', false],
	['Human network 6', 'Could use of the robot negatively alter the user or their human network’s behaviour?', '', false],
	['Human network 7', 'What precautions are taken for those who do not wish to interact with the robot? E.g., signs warning about recording? Or turn recording off?', '', true],
	['Physical environment 1', 'What is the robot\'s intended physical environment?', '', true],
	['Physical environment 2', 'How will it interact with the physical environment elements?', '', true],
	['Physical environment 3', 'How will the robot affect the physical environment elements?', '', true],
	['Sustainability 1', 'Are all stages of pre-deployment (e.g., computer running simulations) running at net neutral 	emissions?', '', false],
	['Sustainability 2', 'Is the robot made of robust, reusable, sustainable materials?', '', false],
	['Sustainability 3', 'Can the robot be powered by a renewable source of energy?', '', false],
	['Sustainability 4', 'Could the robot be made more energy efficient, and what trade-offs would this require?', '', true],
	['Sustainability 5', 'Is the robot repairable and updateable? (see, e.g., right to repair)', '', false],
	['Sustainability 6', 'Has any hazardous material been used? Why were these materials strictly necessary?', '', true],
	['Interpretability 1', 'Is the model optimised for explainability?', '', false],
	['Interpretability 2', 'Is the model optimised for transparency?', '', false],
	['Interpretability 3', 'Is the model optimised for auditability prior to system implementation?', '', false],
	['Interpretability 4', 'Is the model optimised for auditability to analyse failures and assess accountability', '', false],
	['Interpretability 5', 'Is the model optimised for auditability to analyse adherence to jurisdictional 	requirements', '', false],
]  

var deck_business = [
	['Ownership 1', 'What rights does the user not have regarding the robot?', '', true],
	['Ownership 2', 'What impact might this lack of rights have?', '', true],
	['Ownership 3', 'What data does the user not own regarding the robot?', '', true],
	['Ownership 4', 'What impact might this lack of ownership have?', '', true],
	['Ownership 5', 'Does the robot form an integral part of the purchaser (or the person for whom the robot is 	intended)’s life?', '', false],
	['Ownership 6', 'How might its functioning or malfunctioning affect the user both positively and negatively?', '', 	true],
	['Ownership 7', 'In what circumstance might the owner lose access to the robot, including if the company folds? (or ending a subscription model)', '', true],
	['Ownership 8', 'What social, ethical, legal, and moral impacts might this ownership loss have? E.g.,: cybernetic limb on a subscription model', '', true],
	['Ownership 9', 'Does the ownership model contribute to potential negative impacts? (ethically, a payment plan is much more acceptable than a subscription model for a limb)', '', false],
	['Ownership 10', 'Does the robot need to be insured, and if so, does this burden reasonably fall on the producer?', '', true],
	['Ownership 11', 'Is there a revenue stream based around collecting info about the user’s human network?', '', false],
	['Marketing 1', 'Does the marketing for the robot reflect the purpose for which it is optimized?', '', false],
	['Marketing 2', 'Does the marketing reflect the robot’s actual level of autonomy?', '', false],
	['Marketing 3', 'Is the marketing an accurate representation of testing undergone in alignment with the robot’s 	stated purpose?', '', false],
	['Marketing 4', 'Is the marketing capable of misleading any party - regulators, purchasers, the public - as to the 	robot’s capabilities or functionality?', '', false],
	['Literature 1', 'Does the literature accurately address real concerns?', '', false],
	['Literature 2', 'Does the literature highlight the intended purpose of the product?', '', false],
	['Literature 3', 'Is the literature as accessible as possible both in layout and in language? E.g., not hiding 	warnings in fine print?', '', false],
	['Literature 4', 'Is the literature accurate?', '', false],
	['Literature 5', 'Does the literature include instructions on proper disposal of the robot?', '', false],
	['Updates 1', 'How are updates made as accessible as possible?', '', true],
	['Updates 2', 'What level of warning will users have around updates?', '', true],
	['Updates 3', 'Will updates be rolled out regularly, or only when there is a critical safety update?', '', true],
	['Updates 4', 'Are there agreements with a third party around updates, and how do these affect the consumer? E.g., mandatory insurance for vehicles', '', 	true],
	['Updates 5', 'If the robot must be recalled, how will this be communicated?', '', true],
	['Reporting 1', 'Will incidents and issues been made public and accessible?', '', false],
	['Reporting 2', 'Will incidents and issues been repaired to an extent that is appropriate to the level of risk and the type of use of the robot?', '', false],
	['Reporting 3', 'Who has been identified and tasked to monitor these reports?', '', true],
	['Reporting 4', 'What documentation will be accessible to look into why decisions were made?', '', true],
	['Reporting 5', 'How will reporting be implemented?', '', true],
	['Reporting 6', 'Through which mechanisms reporting will be implemented?', '', true],
	['Reporting 7', 'Which data will be provided in the reporting?', '', true],
	['Reporting 8', 'Which parties will reporting be provided to?', '', true],
	['Reporting 9', 'Does the robot incorporate a data recorder for accident investigation?', '', false]
]

var deck_hardware = [
	['Safety-Physical 1', 'Is the design age-appropriate for children?', '', false],
	['Safety-Physical 2', 'Is the design appropriate for interacting with groups with a physical or cognitive 	impairment?', '', false],
	['Safety-Physical 3', 'What design choices were made to make the robot safer to users? E.g., four legs are more 	stable than two', '', true],
	['Safety-Physical 4', 'What conditions affect the robot’s function, and how? E.g., terrain, light levels, noise levels, crowds, subscription, age of the robot.', '', true], #E.g., terrain, light levels, noise levels, incline, altitude, magnetics, temperature, moisture, crowds, battery level, subscription, age of the robot, weather
	['Safety-Physical 5', 'Movement: what forces can the robot bring to bear?', '', true],
	['Safety-Physical 6', 'Could any of its potential movements, including falling, injure a human?', '', false],
	['Safety-Psychological 1', 'Is the robot clearly identifiable as a robot?', '', false],
	['Safety-Psychological 2', 'Is the robot appearance and/or behaviour creating stress, anxiety, fear or discomfort 	during interaction with the user?', '', false],
	['Safety-Psychological 3', 'Is the robot appearance or behaviour eliciting affective bonds (e.g., emotional 	attachment) in the user?', '', false],
	['Autonomy 1', 'What level of autonomy does the robot have, and why?', '', true],
	['Autonomy 2', 'What actions can the robot take internally?', '', true],
	['Autonomy 3', 'What actions can the robot take externally?', '', true],
	['Autonomy 4', 'To what extent and in what circumstances can users vary the robot’s autonomy?', '', true],
	['Autonomy 5', 'To what extent will the user have direct control over the robot’s actions?', '', true],
	['Autonomy 6', 'To what extent will the robot be controlled by members of the user’s human network?', '', true],
	['Autonomy 7', 'Does the robot ‘learn’ throughout its lifecycle?', '', true],
	['Autonomy 8', 'What measures have been taken to ensure robot does not \'learn\' negative elements from: The human network (e.g., language processing;)', '', true],
	['Autonomy 9', 'What measures have been taken to ensure robot does not \'learn\' negative elements from the physical environment (e.g., \'learns\' to brake at crosswalk by \'watching\' other cars)', '', true],
	['Autonomy 10', 'To what extent and when can and will the robot hand over control to a human?', '', true],
	['Autonomy 11', 'What authority does the human require to receive control from the robot?', '', true],
	['Autonomy 12', 'How does the robot communicate that it will hand over control to a human, and with what amount of notice?', '', true],
	['Autonomy 13', 'Can the robot’s decision-making be overridden, and is it clear how to do so in the length of time appropriate for its use? (e.g., driving vs restocking a grocery store)?', '', true],
	['Autonomy 14', 'Does the robot accurately flag where it does not have the information to make an informed decision/action?', '', true],
	['Autonomy 15', 'Does the robot consistently provide its level of accuracy and confidence to the user?', '', true],
	['Autonomy 16', 'What information is provided to the user to overcome confirmation bias or learned carelessness (where the user trusts the robot’s input too greatly)?', '', true],
	['Autonomy 17', 'Can the robot inform a human when it is not functioning properly?', '', true],
	
	['Autonomy 18', 'What parameters are in place to prevent over-specification?', '', true],
	['Autonomy 19', 'What parameters are in place to prevent learning inappropriate behaviours, such as natural language input?', '', true],
	['Autonomy 20', 'Is there an ongoing series of testing to ensure self-learning is proceeding within acceptable parameters?', '', false],
]

var deck_software = [
	['Safety-Psychological 3', 'Could use of the robot cause addiction or dependence?', '', false],
	['Safety-Psychological 4', 'To what extent are these addiction risks mitigated?', '', true],
	['Safety-Psychological 5', 'Does the robot present risks of personification by its user?', '', true],
	['Safety-Psychological 6', 'To what extent are these personification risks mitigated?', '', true],
	['Safety-Psychological 7', 'Are there psychological risks for the robot user or their human network?', '', false],
	['Safety-Psychological 8', 'How are such psychological risks assessed?', '', true],
	['Safety-Psychological 9', 'What are the robot’s potential psychological effects?', '', true],
	['Safety-Psychological 10', 'How has this psychological risk assessment been carried out?', '', true],
	['Safety-Psychological 11', 'What considerations are taken for the robot interacting with a vulnerable users, e.g. a 	minor or disable person?', '', true],
	['Safety-Psychological 12', 'Does the robot have or need a way of communicating with the vulnerable person\'s 	guardian?', '', false],
	['Data Security 1', 'Does the robot require constant connectivity to accomplish its stated purpose?', '', false],
	['Data Security 2', 'How long is data stored?', '', true],
	['Data Security 3', 'Where is data stored? E.g., locally or non-locally?', '', true],
	['Data Security 4', 'Is sensitive data stored locally?', '', false],
	['Data Security 5', 'How is potential data loss prevented? E.g., backups? Mirroring?', '', true],
	['Transparency 1', 'Does the robot passively record data?', '', false],
	['Transparency 2', 'What data is recorded, and why is it necessary for the stated purpose over less invasive data? (E.g., sensor data over camera data)', '', true],
	['Transparency 3', 'Can a data buffer be stored rather than all data? (E.g., if an emergency button is hit, then 	current and immediately previous data will be stored)', '', false],
	['Transparency 4', 'Accountability: can the cause of decisions/actions be identified?', '', false],
	['Transparency 5', 'Is recorded data accessible to designers and investigators?', '', false],
	['Transparency 6', 'What level of reporting are you able to provide?', '', true],
	['Explanations 7', 'Can the robot produce explanations for behaviour? ', '', false],
	['Explanations 8', 'Are these explanations in as clear a form as possible (with a greater need assigned to robots engaging in a safety-critical activity)?	', '', true],  #Please specify: to designers? (sufficiently to update design); to the robot users’ human network?; to regulators?; to investigators of why an accident occurred?
	['Explanations 9', 'How are conflicting explanations resolved (see, e.g., the Rashomon effect)?', '', true],
	['Bias 1', 'What tests have been employed for bias and discrimination?', '', true],
	['Bias 2', 'Why were these tests the most appropriate?', '', true],
	['Bias 3', 'What are the potential discrimination effects?', '', true],
	['Bias 4', 'Can the robot understand a sufficient variety of accents and speech patterns?', '', false],
	['Bias 5', 'Can the robot understand a sufficient variety of speech impediments?', '', false],
	['Bias 6', 'Are there alternative ways for those with disabilities to interact with the robot?', '', false],
	['Bias 7', 'Has the robot been trained on a sufficiently varied set of facial features and racial backgrounds?', '', false],
	['Bias 8', 'Are there alternative ways for those with disabilities to interact with the robot?', '', false],
	['Bias 9', 'Has the design been scrutinised from a cultural bias perspective both for and outside its core user base? (E.g.,: making \'eye contact\' with a user ; terms of address', '', false]
]

var deck_legal = [
	['Privacy 1', 'Has active consent been given for data collected?', '', false],
	['Privacy 2', 'Has the person whom the data concerns been meaningfully informed about its use?', '', false],
	['Privacy 3', 'Was the data lawfully and ethically obtained?', '', false],
	['Privacy 4', 'Does the data use align with the original collection purpose?', '', false],
	['Privacy 5', 'Can individuals be identified from this dataset?', '', false],
	['Privacy 6', 'Can individuals be identified in combination with other datasets?', '', false],
	['Privacy 7', 'Could the purpose of the robot be accomplished using synthetic data?', '', false],
	['Privacy 8', 'Are the user or their human network explicitly asked for consent on data gathered?', '', false],
	['Privacy 9', 'Can individuals, either inside or outside of the human network, block their data from being recorded? E.g., visitors to a home', '', false],
	['Privacy 10', 'Can individuals have their data removed to a meaningful extent?', '', false],
	['Privacy 11', 'Is as minimal data collected as possible? E.g., does the robot need facial/vocal recognition to accomplish its stated purpose?', '', 	false],
	['Privacy 12', 'Is the data that is collected as minimally invasive as possible, or unless specifically requested by a member of the human network? E.g., \'Profile 1 does not drink soda,\' not \'Person 1 is diabetic\'', '', false],
	['Privacy 13', 'Can collection be stopped by the user while the robot is active and/or inactive? See, e.g., guests in 	a home', '', false],
	['Privacy 14', 'Can the robot infer/collect/produce protected characteristics, either by proxy or directly?', '', 	false],
	['Privacy 15', 'Does the data collected need to be stored to accomplish the stated purpose of the robot?', '', false],
	['Privacy 16', 'To what extent do the robot’s actions change based on information collected post-deployment?', '', true],
	['Privacy 17', 'Can the data collected be area-blocked? E.g., signals on bathroom or sensitive areas that signal the 	robot to stop recording', '', false],
	['Privacy 18', 'Why does this data need to be recorded, and are there less intrusive ways to achieve the same 	purpose?', '', true],
	['Privacy 19', 'How might law enforcement or government use this data?', '', true],
	['Privacy 20', 'Who has responsibility when new data is collected?', '', true],
	['Privacy 21', 'Who is the identified data controller?', '', true],
	['Responsibility 1', 'Does any information the robot will recorded be of or related to a vulnerable user (e.g., a minor?)', '', false],
	['Responsibility 2', 'Does the robot have or need a way of communicating with the vulnerable user’s guardian?', '', false],
	['Responsibility 3', 'Who owns the data?', '', true],
	['Responsibility 4', 'Is there any conflict of interest in data ownership?', '', false],
	['Right to repair 1', 'Does the user have the right to modify the robot without affecting their warranty? For example by replacing faculty components?', '', true],
	['Right to repair 2', 'To what extent is the user’s right to modify the robot clearly communicated?', '', true],
	['Right to repair 3', 'Does the user have the right to repair the robot?', '', false],
	['Right to repair 4', 'If the use does not have the right to repair the robot, what are the justifications for blocking this ability?', '', true],
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
	
	# Download implemented for Javascript only:
	if (OS.get_name() == "HTML5"):
		if (OS.has_feature("JavaScript")):
			$SummaryScene/DownloadButton.visible = true
			

func start_deal(deck_type):
	$CardScene/SpriteGeneral.visible = false
	$CardScene/SpriteBusiness.visible = false
	$CardScene/SpriteLegal.visible = false
	$CardScene/SpriteHardware.visible = false
	$CardScene/SpriteSoftware.visible = false
	$CardScene.visible = true
	var deck
	if deck_type == "general":
		deck = deck_general
		$CardScene/text_title.text = "General"
		$SummaryScene/deck_label.text = "General"
		$CardScene/SpriteGeneral.visible = true
	elif deck_type == "business":
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
	# Allow click on cardback to draw (rest of deck autodraws)
	$CardScene/draw_deck.get_child(1).get_node("CardBack/BtnDraw").disabled = false


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
	for card in deck_general:
		if card[2] == "":
			deck_done = false
			break
	$HomeScene/Decks/label_1/deck_done.visible = deck_done
	deck_done = true
	for card in deck_business:
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
	deck_done = true
	for card in deck_legal:
		if card[2] == "":
			deck_done = false
			break
	$HomeScene/Decks/label_5/deck_done.visible = deck_done
	
	
func instantiate_card(card_data):
	var card = card_scene.instance()
	card.rect_position = $CardScene/pos_deck.position
	card.set_card(card_data[0], card_data[1], card_data[3])
	card.name = card_data[0]
	$CardScene/draw_deck.add_child(card)
	# Place under current card (1 index used as 0 is the 'done' deck placeholder)
	$CardScene/draw_deck.move_child(card,1)
	

func deal_deck(deck):
	update_deck_counter()
	
	var summ_pos = $SummaryScene/pos_summ.position
	for vals in deck:
		var card_summ = card_summ_scene.instance()
		card_summ.rect_position = summ_pos
		summ_pos.y += card_summ.rect_size.y * 1.5
#		if summ_pos.y > get_viewport_rect().size.y - (2*card_summ.rect_size.y):
		if summ_pos.y > 900 - (2*card_summ.rect_size.y):
			summ_pos.y = $SummaryScene/pos_summ.position.y
			summ_pos.x += card_summ.rect_size.x * 1.5
		card_summ.set_card(vals[0], vals[1], vals[2])
		card_summ.question = vals[0]
		$SummaryScene/summ_deck.add_child(card_summ)
	
	# Instantiate one card at a time
	for vals in deck:
		if vals[2] == "":
			instantiate_card(vals)
			break
	
	# Create deck empty marker:		
	var card = card_scene.instance()
	card.rect_position = $CardScene/pos_deck.position
	# Disable button
	card.get_node("CardBack/BtnDraw").disabled = true
	$CardScene/draw_deck.add_child(card)
	# Place under current card
	$CardScene/draw_deck.move_child(card,0)
	# Set 'done' background
	card.get_node("CardBack/DoneSprite").visible = true
	
	# Deal whole deck
#	deck.invert()
#	for vals in deck:
#		if vals[2] != "":
#			continue
#		var card = card_scene.instance()
##		card.rect_scale /= 1.2
#		card.rect_position = $CardScene/pos_deck.position
#		card.set_card(vals[0], vals[1], vals[3])
#		card.name = vals[0]
#		#card.get_node("CardBack/BtnDraw").disabled = true
#		$CardScene/draw_deck.add_child(card)
#	deck.invert()


func deal_next_card(name):
	# Find card by name then deal next unanswered card
	var i = 0
	var found = false
	var looped = false
	
	while i < len(active_deck):
		if active_deck[i][0] == name:
			found = true
			if looped:
				break
		# Find first unanswered card after found card:
		elif found == true and active_deck[i][2] == "":
			instantiate_card(active_deck[i])
			break
		i += 1
		
		# Loop once in case some cards skipped
		if i == len(active_deck) and not looped:
			looped = true
			i = 0


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
	$CardScene/tutorial2.visible = false


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
	# (Now handled in _on_NextCardButton_button_up _on_LastCardButton_button_up)
#	while zoomed_i < len(active_deck) and active_deck[zoomed_i][2] == "":
#		zoomed_i += 1
#	if zoomed_i >= len(active_deck):
#		zoomed_i = 0

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
	while active_deck[zoomed_i][2] == "":
		zoomed_i += 1
		if zoomed_i >= len(active_deck):
			zoomed_i = 0
	view_Zoomed()


func _on_LastCardButton_button_up():
	zoomed_i -= 1
	while active_deck[zoomed_i][2] == "":
		zoomed_i -= 1
		if zoomed_i < 0:
			zoomed_i = len(active_deck) - 1
	view_Zoomed()


func _on_SurveyButton_button_up():
	OS.shell_open(SURVEY_URL)


func has_answered_card(deck):
	var ans = ""
	for card in deck:
		if card[2] != "":
			return true
	return false
	
func get_answer_string(deck):
	var res = ""
	var multi_dict = {"ans1":"Yes", "ans2":"Unsure", "ans3":"No"}
	
	for card in deck:
		if card[2] != '':
			if card[3]:
				res += card[0] + "\nQUESTION: " + card[1] + "\nANSWER: " + card[2] +  "\n\n"
			else:
				res += card[0] + "\nQUESTION: " + card[1] + "\nANSWER: "+ multi_dict[card[2]] +  "\n\n"
	return res
	
	
func _on_DownloadButton_button_up():

	var out = ""
	
	if has_answered_card(deck_general):
		out += "\n====== Deck: General ======\n"
		out += get_answer_string(deck_general)

	if has_answered_card(deck_business):
		out += "\n====== Deck: Business ======\n"
		out += get_answer_string(deck_business)
				
	if has_answered_card(deck_hardware):
		out += "\n====== Deck: Hardware ======\n"
		out += get_answer_string(deck_hardware)
	
	if has_answered_card(deck_software):
		out += "\n====== Deck: Software ======\n"
		out += get_answer_string(deck_software)

	if has_answered_card(deck_legal):
		out += "\n====== Deck: Legal ======\n"
		out += get_answer_string(deck_legal)


	var time =  OS.get_datetime()
	var filename = "RoboTIPS_Developer_Framework_Answers_%02d%02d%02d.txt" % [time.year, time.month, time.day]
	
	# Javascript checks redundant as button hidden in ready() if not JS
	if (OS.get_name() == "HTML5"):
		if (OS.has_feature("JavaScript")):
			JavaScript.download_buffer(out.to_utf8(), filename, "text/plain")
		else:
			print("TODO: Javascript Not Available")
	else:
		print("TODO: Non-HTML export")
		
