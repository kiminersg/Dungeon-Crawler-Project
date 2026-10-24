extends CharacterBody2D

@export var max_health := 30
@export var contact_damage := 10

var current_health: int


func _ready():
	current_health = max_health


func take_damage(amount: int):
	current_health -= amount
	
	print("Enemy health: ", current_health)
	
	if current_health <= 0:
		die()


func die():
	queue_free()


func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(contact_damage)
