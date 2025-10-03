extends Node2D

@export var pipe_scene: PackedScene

var game_running: bool
var game_over: bool
var scroll
var score
const scroll_speed : int = 4
var ground_height: int 
var pipes : Array
const Pipe_Delay : int = 90
const pipe_range : int = 100
var screen_size: Vector2i

func _ready():
	screen_size = get_window().size
	ground_height = $mac_ground.get_node("Sprite2D").texture.get_height()
	pipes.clear()
	new_game()
	
	
func new_game():
	game_running = false
	game_over = false
	get_tree().call_group("pipes", "queue_free")
	pipes = []
	score = 0
	$score.hide()
	scroll = 0
	$Tux.reset()
	$start_screen.show()
	$restart_layer.hide()
	$score.text = "Coins Collected: " + str(score)
	$restart_layer/Label.text  = "Your Score Was : " + str(score)

func _input(event):
	if not game_over:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				if not game_running:
					start_game()
				else:
					if $Tux.flying:
						$Tux.flap()

func start_game():
	game_running = true
	$start_screen.hide()
	$score.show()
	$Tux.flying = true
	$Tux.flap()
	$Timer.start()

	
func _process(_delta):
	if game_running:
		scroll += scroll_speed
		if scroll >= screen_size.x:
			scroll = 0
		$mac_ground.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= scroll_speed


func _on_timer_timeout():
	pipe_generator()

func pipe_generator():
	if not game_running:
		return
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + Pipe_Delay
	pipe.position.y = (screen_size.y - ground_height) / 2  + randi_range(-pipe_range, pipe_range)
	pipe.hit.connect(tux_got_hit)
	pipe.scored.connect(tux_scored)
	add_child(pipe)
	pipes.append(pipe)
	
func stop_game():
	$Timer.stop()
	$Tux.flying = false
	$Tux.dead = true
	game_running = false
	game_over = true
	$restart_layer.show()
	
func tux_got_hit():
	$Tux.falling = true
	stop_game()
	
func tux_scored():
	if game_running:
		score += 1
		$score.text = "Coins Collected: " + str(score)
		$restart_layer/Label.text  = "Your Score Was : " + str(score)


func _on_windows_ground_hit():
	$Tux.falling = false
	stop_game()

func _on_restart_layer_restart():
	new_game()


func _on_top_area_body_entered(body: Node2D) -> void:
	if game_running != true:
		return
	$Tux.falling = true
	stop_game()
