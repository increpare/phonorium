extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var deadsound = preload("res://audio/sfx/fallwater.wav")
func _ready():
	connect("body_entered",self,"on_body_enter",[],0)
	pass # Replace with function body.


func on_body_enter(body: Node) -> void:
	if body.name!="Player":
		return
	var player : KinematicBody = body as KinematicBody
	player.global_transform.origin = player.startpos
	$KillAudioStreamPlayer.stream = deadsound
	$KillAudioStreamPlayer.play()
	

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
