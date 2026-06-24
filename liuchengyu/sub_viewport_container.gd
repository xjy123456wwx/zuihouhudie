extends SubViewportContainer

var target_bound: CollisionShape2D = null

func _ready():
	stretch = true
	rect_clip_content = true  # 这里是关键修正
	anchor_left = 0.0
	anchor_top = 0.0
	anchor_right = 1.0
	anchor_bottom = 1.0

func set_clip_bound(bound: CollisionShape2D):
	target_bound = bound

func _process(delta):
	if !target_bound or !target_bound.shape:
		position = Vector2(0, 0)
		size = Vector2(0, 0)
		return

	var cam = get_viewport().get_camera_2d()
	var cam_pos = cam.global_position
	var half_screen = size / 2.0

	var s_rect = target_bound.shape.get_rect()
	var world_rect = Rect2(
		target_bound.global_position + s_rect.position,
		s_rect.size
	)

	var screen_pos = world_rect.position - cam_pos + half_screen
	var screen_rect = Rect2(screen_pos, world_rect.size)

	position = screen_rect.position
	size = screen_rect.size
	
