extends Spatial

export var index:int=-1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var treemat:Material
export var treecount:int=200;
export var minr:float=30;
export var maxr:float=200;
export var treescale_min:float=40;
export var treescale_max:float=50;

func setScale(s:float):
	for i in get_child_count():
		var c :MeshInstance = get_child(i) as MeshInstance;
		if c==null or c.name=="groundquad":
			continue
		c.scale=Vector3(s,s,s)

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
