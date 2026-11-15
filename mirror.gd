extends StaticBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: CanvasItem = $ColorRect

var is_broken: bool = false
var respawn_timer: float = 2.0

func _ready() -> void:
	add_to_group("mirror")

func break_mirror() -> void:
	if is_broken:
		return
	is_broken = true
	sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	await get_tree().create_timer(respawn_timer).timeout
	respawn_mirror()

func respawn_mirror() -> void:
	is_broken = false
	sprite.visible = true
	collision_shape.set_deferred("disabled", false)
	
