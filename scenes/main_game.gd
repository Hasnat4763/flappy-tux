extends Node2D

@export var pipe_scene: PackedScene

var game_running: bool
var game_over: bool
var scroll
var score : int
var high_score : int
const starting_scroll_speed : float = 4.0
var current_scroll_speed = starting_scroll_speed
const max_scroll_speed : float = 10.0
var ground_height: int 
var pipes : Array
const Pipe_Delay : int = 60
const pipe_range : int = 120
var screen_size: Vector2i
var score_saver = "user://high_score.save"
var sigma_identifier = "Beta"


func _ready():
	screen_size = get_window().size
	ground_height = $mac_ground.get_node("Sprite2D").texture.get_height()
	pipes.clear()
	new_game()
	
	
func new_game():
	load_high_score()
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
	current_scroll_speed = starting_scroll_speed




func _input(event):
	if not game_over:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				control_character()
		elif event is InputEventKey:
			if event.is_pressed() and not event.is_echo(): 
				if event.keycode == KEY_SPACE:
					control_character()

func control_character():
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
		scroll += current_scroll_speed
		if scroll >= screen_size.x:
			scroll = 0
		$mac_ground.position.x = -scroll
		for pipe in pipes:
			pipe.position.x -= current_scroll_speed
		
		for i in range(pipes.size() - 1, -1, -1):
			var pipe = pipes[i]
			pipe.position.x -= current_scroll_speed
			if pipe.position.x < - 100:
				pipe.queue_free()
				pipes.remove_at(i)

func _on_timer_timeout():
	pipe_generator()

func pipe_generator():
	if not game_running:
		return
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + Pipe_Delay
	pipe.position.y = (screen_size.y - ground_height) / 2.0  + randi_range(-pipe_range, pipe_range)
	pipe.hit.connect(tux_got_hit)
	pipe.scored.connect(tux_scored)
	add_child(pipe)
	pipes.append(pipe)
	
func stop_game():
	$Timer.stop()
	$Tux.flying = false
	$Tux.dead = true
	$score.hide()
	game_running = false
	game_over = true
	$restart_layer/Label.text  = "Your Score Was : " + str(score)
	if score / 10 == 1:
		sigma_identifier = "Trying"
	elif score / 10 == 2:
		sigma_identifier = "Near Alpha"
	elif score / 10 == 3:
		sigma_identifier = "Very Close to being Alpha"
	elif score / 10 == 4:
		sigma_identifier = "W Alpha"
	elif score / 10 == 5:
		sigma_identifier = "more than an Alpha"
	elif score / 10 == 6:
		sigma_identifier = "Close to 67"
	elif score == 67:
		sigma_identifier = "67 \n Those who nose"
	elif score == 69:
		sigma_identifier = "Sussy Baka"
	elif score / 10 == 7 :
		sigma_identifier = "On the way to be a Sigma"
	elif score / 10 == 8:
		sigma_identifier = "Pro Kali Linux user"
	elif score / 10 == 9:
		sigma_identifier = "Pro Arch Linux user"
	elif score / 10 >= 10:
		sigma_identifier = "VERY SIGMA"
	
	$restart_layer/sigma_identifier.text = "You are currently " + sigma_identifier
	if score > high_score:
		high_score = score
		save_high_score()
		$restart_layer/high_score.text  = "NEW HIGH SCORE!!! : " + str(high_score)
	else:
		$restart_layer/high_score.text  = "High Score : " + str(high_score)
	$restart_layer.show()
	
	
func tux_got_hit():
	$Tux.falling = true
	stop_game()
	
func tux_scored():
	if game_running:
		score += 1
		$score.text = "Coins Collected: " + str(score)
		if score % 10 == 0 and current_scroll_speed < max_scroll_speed:
			current_scroll_speed += 0.5
		


func _on_windows_ground_hit():
	$Tux.falling = false
	stop_game()

func _on_restart_layer_restart():
	new_game()


func _on_top_area_body_entered(_body: Node2D):
	if game_running != true:
		return
	$Tux.falling = true
	stop_game()

func save_high_score():
	var file = FileAccess.open(score_saver, FileAccess.WRITE)
	file.store_var(high_score)

func load_high_score():
	if FileAccess.file_exists(score_saver):
		var file = FileAccess.open(score_saver, FileAccess.READ)
		high_score = file.get_var()
