extends CharacterBody2D

@export var force_max = 1000.0
@export var force_actuelle = 0.0
@export var vitesse_marche = 200.0

var nb_sauts = 0
var timer_total = 0.0

func _physics_process(delta):
	# 1. Update du Timer (on prévient le groupe interface)
	timer_total += delta
	get_tree().call_group("interface", "update_timer", timer_total)

	# 2. Gravité
	if not is_on_floor():
		velocity += get_gravity() * delta
		$AnimatedSprite2D.play("jump")
	
	var direction = Input.get_axis("ui_left", "ui_right")
		
	if is_on_floor():
		# Flip du sprite
		if direction != 0: 
			$AnimatedSprite2D.flip_h = (direction < 0)

		# ÉTAT : CHARGE DU SAUT
		if Input.is_action_pressed("ui_accept"):
			velocity.x = 0
			$AnimatedSprite2D.play("jump")
			force_actuelle = min(force_actuelle + 500 * delta, force_max)
			$AnimatedSprite2D.scale = Vector2(2.0, 2.0)
			
			# On envoie la charge (0 à 100)
			var pourcentage = (force_actuelle / force_max) * 100
			get_tree().call_group("interface", "update_jump_charge", pourcentage)
			
		# ÉTAT : MARCHE
		elif direction != 0:
			velocity.x = direction * vitesse_marche
			$AnimatedSprite2D.play("move")
			$AnimatedSprite2D.scale = Vector2(2.0, 2.0)
			
		# ÉTAT : REPOS
		else:
			velocity.x = 0
			$AnimatedSprite2D.play("static")
			$AnimatedSprite2D.scale = Vector2(1.0, 1.0)

		# DÉCLENCHEMENT DU SAUT
		if Input.is_action_just_released("ui_accept"):
			velocity.y = -force_actuelle
			velocity.x = direction * (force_actuelle * 0.5)
			
			nb_sauts += 1
			get_tree().call_group("interface", "update_jumps", nb_sauts)
			get_tree().call_group("interface", "update_jump_charge", 0) # Remise à zéro HUD
			
			force_actuelle = 0 # Remise à zéro variable interne

	move_and_slide()
