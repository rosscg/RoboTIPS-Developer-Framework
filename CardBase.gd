extends MarginContainer

onready var card_db = preload("res://CardDB.gd")
#onready var card_deck = card_db.deck_1
onready var startpos = rect_position
#var targetpos = Vector2()
#onready var targetpos = get_owner()pos_card
onready var targetpos = get_node("/root/Node2D/CardScene/pos_card").position
onready var discardpos = get_node("/root/Node2D/CardScene/pos_card").position - (rect_size/4)
var t = 0
var DRAWTIME = 0.4
onready var Orig_scale = rect_scale
var inhand_scale = 0.5
enum{
	InDeck
	InHand
	MoveDrawnCardToHand
	DiscardCard
}
var state = InDeck
	
func _ready():
	var card_size = rect_size
	$CardBack.visible = true
	$Border.scale *= card_size/$Border.texture.get_size()
	$CardBack/Sprite.scale *= card_size/$CardBack/Sprite.texture.get_size()
	#$VBoxContainer/TextBar2/TextEdit.rect_size.x = card_size.x - 30

func _physics_process(delta):
	match state:
		InHand:
			pass
		InDeck:
			pass
		MoveDrawnCardToHand: # animate from the deck to my hand
			if t <= 1: # Always be a 1
				rect_position = startpos.linear_interpolate(targetpos, t)
				#rect_rotation = startrot * (1-t) + targetrot*t
				rect_scale.x = Orig_scale.x * abs(2*t - 1) * (1+(inhand_scale*t))
				rect_scale.y = Orig_scale.y * (1+(inhand_scale*t))
				if $CardBack.visible:
					if t >= 0.5:
						$CardBack.visible = false
				t += delta/float(DRAWTIME)
			else:
				rect_position = targetpos
				#rect_rotation = targetrot
				state = InHand
				t = 0
		DiscardCard:
			if t <= 1: # Always be a 1
				rect_position = targetpos.linear_interpolate(discardpos, t)
				#rect_rotation = startrot * (1-t) + targetrot*t
				t += delta/(float(DRAWTIME)/2)
				rect_scale = Orig_scale * (1+inhand_scale) * (1-0.5*t)
				modulate.a = 1-t
			else:
				get_parent().get_parent().get_parent().toggle_deck_draw()
				queue_free()
	

func _on_BtnDraw_button_up():
	get_parent().get_parent().get_node("tutorial").visible = false
	get_parent().get_parent().get_parent().deal_next_card(self.name)
	state = MoveDrawnCardToHand
	get_parent().get_parent().get_parent().toggle_deck_draw()
	

func set_card(title, text, isTextInput=false):
	$VBoxContainer/TopBar/Title/CenterContainer/Label.text = title
	$VBoxContainer/TextBar/Title/CenterContainer/Label.text = text
	
	$VBoxContainer/ButtonBar.visible=(not isTextInput)
	$VBoxContainer/TextBar2.visible=isTextInput
	$VBoxContainer/ButtonBar2.visible=isTextInput
	
#	if isTextInput:
#		$VBoxContainer/TextBar2.rect_size.y = 350 - \
#			$VBoxContainer/TextBar2.rect_position.y - 30

		


func _on_Button1_button_up():
	t=0
	$VBoxContainer/ButtonBar/Button2.modulate.a = 0
	$VBoxContainer/ButtonBar/Button3.modulate.a = 0
	get_parent().get_parent().get_parent().card_answer(self.name, 'ans1')
	state = DiscardCard

func _on_Button2_button_up():
	t=0
	$VBoxContainer/ButtonBar/Button1.modulate.a = 0
	$VBoxContainer/ButtonBar/Button3.modulate.a = 0
	get_parent().get_parent().get_parent().card_answer(self.name, 'ans2')
	state = DiscardCard

func _on_Button3_button_up():
	t=0
	$VBoxContainer/ButtonBar/Button1.modulate.a = 0
	$VBoxContainer/ButtonBar/Button2.modulate.a = 0
	get_parent().get_parent().get_parent().card_answer(self.name, 'ans3')
	state = DiscardCard


func _on_ButtonText_button_up():
	t=0
	$VBoxContainer/ButtonBar2/ButtonText.modulate.a = 0
	get_parent().get_parent().get_parent().card_answer(self.name, 
		$VBoxContainer/TextBar2/TextEdit.text)
	state = DiscardCard
