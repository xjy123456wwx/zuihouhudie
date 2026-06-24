extends Node2D

@export var room_area: Area2D
@export var camera_boundary: CollisionShape2D

var main_camera: Camera2D = null

func _ready():
	# 先判断 room_area 不为空，再连接信号，防止崩溃
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
	if not main_camera or not camera_boundary.shape:
		return
	
	var shape_rect = camera_boundary.shape.get_rect()
	var global_pos = camera_boundary.global_position
	
	main_camera.limit_enabled = true  # 强制开启限位
	main_camera.limit_left = global_pos.x + shape_rect.position.x
	main_camera.limit_right = global_pos.x + shape_rect.end.x
	main_camera.limit_top = global_pos.y + shape_rect.position.y
	main_camera.limit_bottom = global_pos.y + shape_rect.end.y
	main_camera.force_update_scroll()  # 强制刷新相机
