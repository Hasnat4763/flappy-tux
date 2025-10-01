extends Node2D

@export var pipe_scene: PackedScene

var game_running: bool
var game_over: bool
var scroll
var score
const scroll_speed : int = 4
var ground_height: int 
var pipes : Array
const Pipe_Delay : int = 100
const pipe_range : int = 50
var screen_size: Vector2i

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	ground_height = $windows_ground.get_node("Sprite2D").texture.get_height()
	pipes.clear()
	new_game()
	
	
func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$Tux.reset()

func _input(event):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
				if game_running == false:
					start_game()
				else:
					if $Tux.flying:
						$Tux.flap()
					
				
				
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func start_game():
	game_running = true
	$Tux.flying = true
	$Tux.flap()
	$Timer.start()

	
func _process(delta):
	if game_running:
		scroll += scroll_speed
	if scroll >= screen_size.x:
		scroll = 0
	$windows_ground.position.x = -scroll
	for pipe in pipes:
		pipe.position.x -= scroll_speed


func _on_timer_timeout():
	pipe_generator()

func pipe_generator():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + Pipe_Delay
	pipe.position.y = (screen_size.y - ground_height) / 2  + randi_range(-pipe_range, pipe_range)
	pipe.hit.connect(bird_got_hit)
	add_child(pipe)
	pipes.append(pipe)
	
func bird_got_hit():
	pass
