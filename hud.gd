extends CanvasLayer

# Utilise bien le clic droit -> "Access as Unique Name" sur tes nodes dans l'éditeur !
@onready var jump_label = %JumpLabel
@onready var timer_label = %TimerLabel
@onready var jump_bar = %JumpBar
@onready var stamina_bar = %StaminaBar

func _ready():
	add_to_group("interface")
	print("--- LE HUD EST BIEN LANCE ---")
	
	# Test manuel : on force les labels pour voir s'ils existent
	if %JumpLabel: 
		%JumpLabel.text = "TEST OK"
		print("Label trouvé !")
	else:
		print("ERREUR : Label introuvable, vérifie le NOM UNIQUE (%)")

func update_jumps(count: int):
	if jump_label: 
		jump_label.text = "Jumps: " + str(count)

func update_timer(time: float):
	if timer_label:
		var mins = int(time) / 60
		var secs = int(time) % 60
		timer_label.text = "Time: " + str(mins).pad_zeros(2) + ":" + str(secs).pad_zeros(2)

func update_jump_charge(value: float):
	if jump_bar: 
		jump_bar.value = value

func update_stamina(value: float):
	if stamina_bar: 
		stamina_bar.value = value
