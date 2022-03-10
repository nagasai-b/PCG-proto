extends RichTextLabel

func _ready():
	pass
	
# Called when the node enters the scene tree for the first time.
func call_me(text):
	set_text('Seed: '+ str(text))
	pass




