extends Area

var scene_base:Node

func _ready():
	self.connect("body_entered", self, "player_entered")
	self.connect("body_exited", self, "player_exited")
	scene_base = get_parent().get_parent().get_parent()

func player_entered(player):
	if player.name!="Player":
		return
	
	scene_base.call("setZone",get_parent().name,self.global_transform.origin)

func player_exited(player):
	if player.name!="Player":
		return
		
	scene_base.call("unsetZone")
