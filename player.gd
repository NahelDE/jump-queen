extends CharacterBody2D

@export var force_max = 1000.0
@export var force_actuelle = 0.0

func _physics_process(delta):
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			force_actuelle+=500*delta
			force_actuelle = min(force_actuelle, force_max) # sinon le max est useless lol
			
		if Input.is_action_just_released("ui_accept"):
			velocity.y=-force_actuelle # du coup le "-" car y monte en négatif 
			force_actuelle=0

	move_and_slide()
