extends Control

@onready var top_mask: ColorRect = $TopMask
@onready var bottom_mask: ColorRect = $BottomMask
@onready var left_mask: ColorRect = $LeftMask
@onready var right_mask: ColorRect = $RightMask

var current_room_boundary: CollisionShape2D = null

func _ready():
	z_index = 9999
	visible = true

func set_current_room(boundary: CollisionShape2D):
	current_room_boundary = boundary

func _process(delta):
	if not current_room_boundary or not current_room_boundary.shape:
		top_mask.size = Vector2(size.x, size.y)
		bottom_mask.size = Vector2(0, 0)
		left_mask.size = Vector2(0, 0)
		right_mask.size = Vector2(0, 0)
		return

	var camera = get_viewport().get_camera_2d()
	var cam_pos = camera.global_position
	var half_size = size / 2.0

	var shape_rect = current_room_boundary.shape.get_rect()
	var room_global_rect = Rect2(
		current_room_boundary.global_position + shape_rect.position,
		shape_rect.size
	)

	var room_screen_rect = Rect2(
		room_global_rect.position - cam_pos + half_size,
		room_global_rect.size
	)
	var r = room_screen_rect

	top_mask.size = Vector2(size.x, r.position.y)
	top_mask.position = Vector2(0, 0)

	bottom_mask.size = Vector2(size.x, size.y - r.end.y)
	bottom_mask.position = Vector2(0, r.end.y)

	left_mask.size = Vector2(r.position.x, r.size.y)
	left_mask.position = Vector2(0, r.position.y)

	right_mask.size = Vector2(size.x - r.end.x, r.size.y)
	right_mask.position = Vector2(r.end.x, r.position.y)
