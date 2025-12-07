extends Panel

var time: float = 20.0   # start at 20 seconds

func _process(delta) -> void:
	time -= delta          # countdown

	if time < 0:
		time = 0            # prevent negative numbers

	var seconds = int(time)
	$Label.text = "%02d" % seconds

	if seconds == 0:
		get_tree().change_scene_to_file("res://scenes/victory.tscn")
