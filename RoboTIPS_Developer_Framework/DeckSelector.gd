extends MarginContainer

onready var startpos = rect_position
onready var targetpos = get_node("/root/Node2D/CardScene/pos_deck").position
onready var x_dist = abs((startpos-targetpos).x)
onready var DRAWTIME = log(x_dist)/10 # Log scale so closer decks still animate
var t = 0

enum{
	InDeck
	MoveDrawnCardToHand
}
var state = InDeck

	
func _ready():
	var card_size = rect_size
	$CardBack/Sprite.scale *= card_size/$CardBack/Sprite.texture.get_size()


func _physics_process(delta):
	match state:
		InDeck:
			pass
		MoveDrawnCardToHand:
			if t <= 1:
				rect_position = startpos.linear_interpolate(targetpos, t)
				t += delta/DRAWTIME
			else:
				rect_position = startpos
				for n in get_parent().get_children():
					n.visible = true
					get_parent().get_parent().visible = false
				get_parent().get_parent().get_parent().start_deal(self.name.split("_")[1])
				state = InDeck
				t = 0


func _on_BtnDraw_button_up():
	get_parent().get_parent().get_node("tutorial").visible = false
	state = MoveDrawnCardToHand
	#get_node("/root/Node2D/CardScene/pos_card").position
	#get_parent().visible = false
	# Hide decks not selected:
	for n in get_parent().get_children():
		if n != self:
			n.visible = false
