extends CharacterBody2D

@export var force_max = 1000.0
@export var force_actuelle = 0.0
@export var vitesse_marche = 200.0

func _physics_process(delta):
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# récup la direction
	var direction = Input.get_axis("ui_left", "ui_right")
		
	if is_on_floor():
		
		if not Input.is_action_pressed("ui_accept"):
			velocity.x = direction * vitesse_marche
		else:
			velocity.x = 0 # psq si on charge on s'arrête 
			force_actuelle += 500 * delta
			force_actuelle = min(force_actuelle, force_max)
					
		if Input.is_action_just_released("ui_accept"):
			velocity.y = -force_actuelle
			velocity.x = direction * (force_actuelle * 0.5) # test impulsion 
			force_actuelle = 0
			
		if direction != 0:
			$AnimatedSprite2D.flip_h = (direction < 0) #pour pas marcher à reculons

	move_and_slide()
