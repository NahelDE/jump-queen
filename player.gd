extends CharacterBody2D

@export var force_max = 2500.0 
@export var force_actuelle = 0.0
@export var vitesse_marche = 500.0
@export var multiplicateur_gravite = 2.5 # Un peu plus lourd pour compenser l'absence d'inertie

var nb_sauts = 0
var timer_total = 0.0

func _physics_process(delta):
	timer_total += delta
	get_tree().call_group("interface", "update_timer", timer_total)

	# 1. GESTION DE L'AIR (Trajectoire verrouillée)
	if not is_on_floor():
		velocity += get_gravity() * multiplicateur_gravite * delta
		
		$AnimatedSprite2D.animation = "falling"
		$AnimatedSprite2D.frame = 0 if velocity.y < 0 else 1
	
	# 2. GESTION DU SOL
	else:
		var direction = Input.get_axis("ui_left", "ui_right")
		
		if direction != 0: 
			$AnimatedSprite2D.flip_h = (direction < 0)

		# ÉTAT : CHARGE DU SAUT
		if Input.is_action_pressed("ui_accept"):
			velocity.x = 0 # Arrêt immédiat (plus d'inertie)
			$AnimatedSprite2D.animation = "jump" 
			force_actuelle = min(force_actuelle + 1500 * delta, force_max)
			get_tree().call_group("interface", "update_jump_charge", (force_actuelle / force_max) * 100)
			
		# ÉTAT : MARCHE
		elif direction != 0:
			velocity.x = direction * vitesse_marche # Vitesse directe
			$AnimatedSprite2D.play("move")
			
		# ÉTAT : REPOS
		else:
			velocity.x = 0 # Arrêt direct
			$AnimatedSprite2D.animation = "static"

		# 3. DÉCLENCHEMENT DU SAUT (Angle proportionnel à la force)
		if Input.is_action_just_released("ui_accept"):
			velocity.y = -force_actuelle
			
			# L'angle est géré ici : la vitesse horizontale dépend de la force de charge
			# Plus tu charges haut, plus tu sautes loin sur le côté
			if direction != 0:
				velocity.x = direction * (force_actuelle * 0.5) 
			else:
				velocity.x = 0
			
			nb_sauts += 1
			get_tree().call_group("interface", "update_jumps", nb_sauts)
			get_tree().call_group("interface", "update_jump_charge", 0)
			force_actuelle = 0

	move_and_slide()
