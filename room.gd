extends Node2D

@export var room_area: Area2D
@export var camera_boundary: CollisionShape2D

var main_camera: Camera2D = null

func _ready():
	if room_area != null:
		room_area.body_entered.connect(_on_room_entered)
		room_area.body_exited.connect(_on_room_exited)

func _on_room_entered(body: Node2D):
	if body.is_in_group("player"):
		main_camera = get_viewport().get_camera_2d()
		set_camera_boundary()

func _on_room_exited(body: Node2D):
	if body.is_in_group("player"):
		main_camera = null

func set_camera_boundary():
	# 先判断 camera_boundary 本身是否为空，再判断它的 shape
	if not main_camera or not camera_boundary or not camera_boundary.shape:
		return

	var shape_rect = camera_boundary.shape.get_rect()
	var global_pos = camera_boundary.global_position

	main_camera.limit_enabled = true
	main_camera.limit_left = global_pos.x + shape_rect.position.x
	main_camera.limit_right = global_pos.x + shape_rect.end.x
	main_camera.limit_top = global_pos.y + shape_rect.position.y
	main_camera.limit_bottom = global_pos.y + shape_rect.end.y
	main_camera.force_update_scroll()
	
