extends CharacterBody2D

@export var force_max = 1000.0
@export var force_actuelle = 0.0
@export var vitesse_marche = 200.0

func _physics_process(delta):
	# 1. Gravité et animation de saut (en l'air)
	if not is_on_floor():
		velocity += get_gravity() * delta
		$AnimatedSprite2D.play("jump") # On utilise .play() c'est plus propre
	
	# 2. Récupérer la direction
	var direction = Input.get_axis("ui_left", "ui_right")
		
	if is_on_floor():
		# Gérer le Flip du sprite
		if direction != 0:
			$AnimatedSprite2D.flip_h = (direction < 0)

		# LOGIQUE AU SOL
		if Input.is_action_pressed("ui_accept"):
			# ÉTAPE : CHARGE DU SAUT
			velocity.x = 0
			$AnimatedSprite2D.play("jump") # Ou une animation de charge si tu as
			force_actuelle = min(force_actuelle + 500 * delta, force_max)
			$AnimatedSprite2D.scale = Vector2(2.0,2.0)
			
		elif direction != 0:
			# ÉTAPE : MARCHE
			velocity.x = direction * vitesse_marche
			$AnimatedSprite2D.play("move")
			$AnimatedSprite2D.scale = Vector2(2.0,2.0)
		else:
			# ÉTAPE : REPOS
			velocity.x = 0
			$AnimatedSprite2D.play("static")
			$AnimatedSprite2D.scale = Vector2(1.0,1.0)

		# 3. RELÂCHER LE SAUT
		if Input.is_action_just_released("ui_accept"):
			velocity.y = -force_actuelle
			velocity.x = direction * (force_actuelle * 0.5)
			force_actuelle = 0

	move_and_slide()
