extends Node


func _process(delta):	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen
	if Input.is_action_just_pressed("toggle_audio"):
		var mute = 	AudioServer.is_bus_mute(AudioServer.get_bus_index("Master"))
		AudioServer.set_bus_mute (AudioServer.get_bus_index("Master"),!mute)
		
