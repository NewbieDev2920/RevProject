extends CanvasLayer

var gameStarted = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameStarted = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if gameStarted:
		showFPS()

func showFPS()-> void:
	$FpsLabel.text = str(Engine.get_frames_per_second())
	
