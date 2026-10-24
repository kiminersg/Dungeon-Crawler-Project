extends CharacterBody2D

@export var speed := 200.0
@export var attack_damage := 10
@export var max_health := 100

@onready var attack_hitbox = $AttackHitbox

var last_direction := Vector2.RIGHT
var current_health: int

func _ready():
	current_health = max_health
	attack_hitbox.monitoring = false

func _physics_process(_delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction != Vector2.ZERO:
		last_direction = direction
	
	velocity = direction * speed
	
	move_and_slide()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		attack()


func attack():
	print("ATTACK!")
	
	attack_hitbox.position = last_direction * 30
	
	attack_hitbox.monitoring = true
	
	await get_tree().create_timer(0.15).timeout
	
	attack_hitbox.monitoring = false

func take_damage(amount: int):
	current_health -= amount
	
	print("Player health: ", current_health)
	
	if current_health <= 0:
		die()

func die():
	print("PLAYER DIED!")
	
	GameState.deaths += 1
	
	print("Total deaths: ", GameState.deaths)
	
	get_tree().reload_current_scene()
	
func _on_attack_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(attack_damage)
