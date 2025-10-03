extends CharacterBody2D

const GRAVITY : int = 1000
const MAX_VELOCITY: int = 600
const FLAPPING_SPEED: int = -500
var flying: bool = false
var falling: bool = false
var dead: bool = false
const start_pos = Vector2(100, 400)

func reset():
	falling = false
	flying = false
	dead = false
	position = start_pos
	set_rotation(0)
	$Animation_Fly.play("idle")
	
	
	
func _physics_process(delta):
	if flying or falling:
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_VELOCITY:
			velocity.y = MAX_VELOCITY
		move_and_slide()
			
		if flying:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$Animation_Fly.play("jump")
		elif falling:
			$Animation_Fly.play("death")
			
	else:
		if dead:
			$Animation_Fly.play("death")
		else:
			$Animation_Fly.play("idle")
		

		
func flap():
	velocity.y = FLAPPING_SPEED
