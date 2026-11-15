extends Node2D

@export var max_bounces: int = 5
@export var laser_length: float = 2000.0

var is_fired: bool = false

func _process(_delta: float) -> void:
	# Only let the player aim BEFORE they fire the laser!
	if not is_fired:
		look_at(get_global_mouse_position())
		
		# Press SPACE or RIGHT-CLICK to fire!
		if Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			is_fired = true
			
	queue_redraw()

func _draw() -> void:
	# If not fired yet, draw a thin dotted/faint aiming line so the player knows where it's pointing
	if not is_fired:
		draw_line(Vector2.ZERO, Vector2.RIGHT * 150, Color(1, 1, 1, 0.4), 2.0)
		return

	# --- EVERYTHING BELOW ONLY RUNS AFTER FIRING ---
	var space_state = get_world_2d().direct_space_state
	var current_origin = global_position
	var current_direction = Vector2.RIGHT.rotated(global_rotation)
	
	for i in range(max_bounces):
		var query = PhysicsRayQueryParameters2D.create(current_origin, current_origin + (current_direction * laser_length))
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		
		if result:
			var hit_point = result.position
			var collider = result.collider
			
			if collider.is_in_group("mirror"):
				draw_line(to_local(current_origin), to_local(hit_point), Color.RED, 4.0)
				current_direction = current_direction.bounce(result.normal)
				current_origin = hit_point + (current_direction * 0.1)
			elif collider.is_in_group("exit"):
				draw_line(to_local(current_origin), to_local(hit_point), Color.GREEN, 4.0)
				print("Level Won!")
				var win_label = get_parent().get_node_or_null("WinLabel")
				if win_label:
					win_label.visible = true
				break
			else:
				draw_line(to_local(current_origin), to_local(hit_point), Color.RED, 4.0)
				break
		else:
			draw_line(to_local(current_origin), to_local(current_origin + (current_direction * laser_length)), Color.RED, 4.0)
			break
