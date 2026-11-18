extends Area3D

@onready var player: CharacterBody3D = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	pass # Replace with function body.


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player.CurrentGravity = player.GravityOrientation.Down
		player.animation_player.play("Orient_DOWN")
		
