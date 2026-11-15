extends Area2D

func _ready() -> void:
	add_to_group("exit")
	# Connect the signal so we know when something enters the exit
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# If a player or object touches it (or you can use this for future elements)
	pass

# We can also add a custom check if needed, or let the laser print its win message
