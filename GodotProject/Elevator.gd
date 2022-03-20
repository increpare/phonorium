extends Spatial

var button_area
var spatial_button

var startPos = null
var root
var player_on = false
var at_top = false
var at_bottom=true

export var speed:float = 1
export var endPos:Vector3 = Vector3(1,0,0)
export var player_path:NodePath 

var player : Spatial

# Called when the node enters the scene tree for the first time.
func _ready():

	root = get_tree().get_root()
	startPos = self.translation
	button_area = $Area	
	
	player = get_node(player_path) as Spatial 
	
	
	button_area.connect("body_entered", self, "on_body_enter")
	button_area.connect("body_exited", self, "on_body_exit")
	
	
	pass # Replace with function body.

func _physics_process(delta):
	if global_transform.origin.y < player.global_transform.origin.y:
		$Platform/KinematicBody/CollisionShape.disabled=false
	else:
		$Platform/KinematicBody/CollisionShape.disabled=true
		
func elevatorTop(_object: Object, strn:NodePath) -> void:
	print("top")
	at_top=true
	
	
	if at_top and not player_on:
		at_top=false
		at_bottom=false
		
		var duration = self.translation.distance_to(startPos)/speed
		$Spatial/Button_unpressed.visible=true
		$Tween.remove_all()
		$Tween.interpolate_property(
			self,"translation",
			self.translation,
			startPos,
			duration,
			Tween.TRANS_LINEAR, 
			Tween.EASE_IN_OUT
			)
		$Whirr_down.play()
		$Whirr_up.stop()
		$Tween.start()
		if $Tween.is_connected("tween_completed",self,"elevatorTop"):
			$Tween.disconnect("tween_completed",self,"elevatorTop")
		$Tween.connect("tween_completed", self, "elevatorBottom",[],CONNECT_ONESHOT)
		
	
func elevatorBottom(_object: Object, strn:NodePath) -> void:
	print("Bottom")
	at_bottom=true
	

	
	
func on_body_enter(body: Node) -> void:
	if body.name!="Player":
		return
		
	print("enter")
	print(body)
	
	if not $Spatial/Button_unpressed.visible == false:
		$Spatial/Button_unpressed.visible=false		
		$Button_down.play()
	
	player_on = true
	
	if at_bottom and player_on:
		at_top=false
		at_bottom=false
		
		var duration = self.translation.distance_to(endPos)/speed		
		$Tween.remove_all()
		$Tween.interpolate_property(
			self,"translation",
			self.translation,
			endPos,
			duration,
			Tween.TRANS_LINEAR, 
			Tween.EASE_IN_OUT
			)
		$Whirr_down.stop()
		$Whirr_up.play()
		$Tween.start()
		if $Tween.is_connected("tween_completed",self,"elevatorBottom"):
			$Tween.disconnect("tween_completed",self,"elevatorBottom")
		$Tween.connect("tween_completed", self, "elevatorTop",[],CONNECT_ONESHOT)
	
	
func on_body_exit(body: Node) -> void:
	if body.name!="Player":
		return			
	
	if not $Spatial/Button_unpressed.visible == true:
		$Spatial/Button_unpressed.visible=true		
		$Button_up.play()
		
	player_on = false

	if at_top and not player_on:	
		at_top=false
		at_bottom=false
		
		var duration = self.translation.distance_to(startPos)/speed
		$Tween.remove_all()
		$Tween.interpolate_property(
			self,"translation",
			self.translation,
			startPos,
			duration,
			Tween.TRANS_LINEAR, 
			Tween.EASE_IN_OUT
			)
		$Whirr_up.stop()
		$Whirr_down.play()
		$Tween.start()
		if $Tween.is_connected("tween_completed",self,"elevatorTop"):
			$Tween.disconnect("tween_completed",self,"elevatorTop")
		$Tween.connect("tween_completed", self, "elevatorBottom",[],CONNECT_ONESHOT)
		
	print("exit")
	print(body)


