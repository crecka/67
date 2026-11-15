extends Node2D

var max_mirrors: int = 4
var mirrors_placed: int = 0
var last_spawned_mirror: StaticBody2D = null

func _ready() -> void:
	update_mirror_counter()

func _unhandled_input(event: InputEvent) -> void:
	# Press 'R' at any time to restart the level!
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		get_tree().reload_current_scene()

	# Only allow actions if the laser hasn't been fired yet
	var laser = get_node_or_null("laser")
	if laser and laser.is_fired:
		return

	if event is InputEventMouseButton and event.pressed:
		# Left-click to place a mirror
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if mirrors_placed < max_mirrors:
				spawn_mirror(get_global_mouse_position())
				mirrors_placed += 1
				update_mirror_counter()
			else:
				print("Out of mirrors!")
		
		# Scroll wheel rotates the last placed mirror AFTER it spawns
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if is_instance_valid(last_spawned_mirror):
				last_spawned_mirror.rotation += deg_to_rad(15.0)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if is_instance_valid(last_spawned_mirror):
				last_spawned_mirror.rotation -= deg_to_rad(15.0)

func update_mirror_counter() -> void:
	var label = get_node_or_null("MirrorCounterLabel")
	if label:
		var remaining = max_mirrors - mirrors_placed
		label.text = "Mirrors Left: " + str(remaining)

func spawn_mirror(pos: Vector2) -> void:
	var mirror = StaticBody2D.new()
	mirror.add_to_group("mirror")
	
	var sprite = Sprite2D.new()
	sprite.name = "Sprite2D"
	
	var texture_path = "res://image-removebg-preview.png"
	if ResourceLoader.exists(texture_path):
		sprite.texture = load(texture_path)
	else:
		print("ERROR: Could not find mirror image at: ", texture_path)
		
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = Vector2(0.22, 0.25) 
	mirror.add_child(sprite)
	
	var col = CollisionShape2D.new()
	col.name = "CollisionShape2D"
	var shape = RectangleShape2D.new()
	shape.size = Vector2(110, 14)
	col.shape = shape
	mirror.add_child(col)
	
	mirror.set_script(preload("res://image-removebg-preview.png"))
	
	# 1. ADD TO SCENE TREE FIRST
	add_child(mirror)
	
	# 2. SET GLOBAL POSITION AFTER (This fixes the offset/misplacement)
	mirror.global_position = pos
	mirror.rotation = 0.0
	
	# Track this newly spawned mirror so you can rotate it immediately
	last_spawned_mirror = mirror
