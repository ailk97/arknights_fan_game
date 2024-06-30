extends Node

var _nextLocation : String

func sceneChange(nextLocation):
	_nextLocation = nextLocation
	var loadingScreen = preload("res://loading_screen.tscn")
	get_tree().change_scene_to_packed(loadingScreen)
