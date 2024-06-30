extends Control

var target_scene_path = SceneLoader._nextLocation

var loading_status : int
var progress : Array[float]

@onready var progress_bar : ProgressBar = $ProgressBar

func _ready() -> void:
	print("	⟳ Загрузка местности... ⟳")
	# Request to load the target scene:
	ResourceLoader.load_threaded_request(target_scene_path)
	
func _process(_delta: float) -> void:
	# Update the status:
	loading_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	
	# Check the loading status:
	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100 # Change the ProgressBar value
		ResourceLoader.THREAD_LOAD_LOADED:
			# When done loading, change to the target scene:
			var Scene = ResourceLoader.load_threaded_get(target_scene_path)
			get_tree().change_scene_to_packed(Scene)
			Events.update()
			#Events.sceneChanging = false
		ResourceLoader.THREAD_LOAD_FAILED:
			# Well some error happend:
			print("Error. Could not load Resource")
