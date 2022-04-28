extends Area



func _ready():
	self.connect("body_entered", self, "player_entered")
	self.connect("body_exited", self, "player_exited")

func player_entered(player):
	print("entered ",player);

func player_exited(player):
	print("exited ",player);
