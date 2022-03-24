extends Spatial

export var text:String = "" setget setText
export var billboard:bool = false

func setText(t:String):
	text=t
	updateGraphic()
	


func updateGraphic():	
	$Sprite3D.billboard=self.billboard
	$Viewport/Label.text=self.text
	$Viewport.render_target_update_mode = Viewport.UPDATE_ONCE
	
func _ready():
	updateGraphic()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
