extends Spatial

var frames:Array = [
	[
		preload("res://textures/ending/texts/texts1.png"),
		preload("res://textures/ending/ending_black.png")
	],
	[
		preload("res://textures/ending/texts/texts1.png"),
		preload("res://textures/ending/ending0.png")
	],
	[
		preload("res://textures/ending/texts/texts2.png"),
		preload("res://textures/ending/ending0.png")
	],
	[
		preload("res://textures/ending/texts/texts3.png"),
		preload("res://textures/ending/ending0.png")
	],
	[
		preload("res://textures/ending/texts/texts3.png"),
		preload("res://textures/ending/ending1.png")
	],
	[
		preload("res://textures/ending/texts/texts4.png"),
		preload("res://textures/ending/ending13.png")
	],
	[
		preload("res://textures/ending/texts/texts5.png"),
		preload("res://textures/ending/ending12.png")
	],
	[
		preload("res://textures/ending/texts/texts6.png"),
		preload("res://textures/ending/ending_black.png")
	],
	[
		preload("res://textures/ending/texts/texts7.png"),
		preload("res://textures/ending/ending_black.png")
	],
	[
		preload("res://textures/ending/texts/texts8.png"),
		preload("res://textures/ending/ending_black.png")
	],
	[
		preload("res://textures/ending/texts/texts9.png"),
		preload("res://textures/ending/ending_black.png")
	],
	[
		preload("res://textures/ending/texts/texts10.png"),
		preload("res://textures/ending/ending3.png")
	],
]


var index=0
var ready=true

func onready():
	print(ready)
	ready=true
	
func setframes():
	$Camera/Sprite_Left.texture = frames[index][0]
	$Camera/Sprite_Right.texture = frames[index][1]
	
# Called when the node enters the scene tree for the first time.
func _ready():
	setframes()
	$Tween.remove_all()
	$Tween.interpolate_property(
		$Camera/Sprite_Left,"opacity",
		0,
		1,
		1,
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT
		)
	$Tween.start()
	$Tween.connect("tween_completed", self, "onready",[],CONNECT_ONESHOT)
	

var started

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not ready:
		return	
	if Input.is_action_just_pressed("LMB"):
		print("CLICK")
		if (index+1)<frames.size():
			index = index + 1
			setframes()
	
