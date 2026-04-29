extends CharacterBody2D

const gravity = 2000
const speed_walk = 300
const speed_run = 550
const jump_force = 800

var max_jumps = 2
var jumps_remaining = max_jumps

@onready var walk_anim = $walkAnimatedSprite2D
@onready var jump_anim = $jumpAnimatedSprite2D
@onready var run_anim = $runAnimatedSprite2D
@onready var buzhuo_anim = $buzhuoAnimatedSprite2D

var jump_trigger = false
var is_buzhuo = false

func _ready():
	# 开局直接把捕捉动画隐藏，避免叠在身上
	buzhuo_anim.visible = false

func _physics_process(delta):
	# 重力
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		jumps_remaining = max_jumps

	# 方向
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	# 移动速度
	if Input.is_action_pressed("run"):
		velocity.x = direction * speed_run
	else:
		velocity.x = direction * speed_walk

	# 跳跃
	if jump_trigger:
		jump_trigger = false
		velocity.y = -jump_force
		jumps_remaining -= 1

	# 左右翻转
	if direction != 0:
		walk_anim.scale.x = -1 if direction < 0 else 1
		jump_anim.scale.x = -1 if direction < 0 else 1
		run_anim.scale.x = -1 if direction < 0 else 1
		buzhuo_anim.scale.x = -1 if direction < 0 else 1

	# 只在地面、不在捕捉状态时，按右键触发
	if Input.is_action_just_pressed("buzhuo") and not is_buzhuo and is_on_floor():
		is_buzhuo = true
		velocity.x = 0

		walk_anim.visible = false
		run_anim.visible = false
		jump_anim.visible = false

		buzhuo_anim.visible = true
		buzhuo_anim.play("buzhuo")

	# 捕捉动画播完自动结束、隐藏
	if is_buzhuo and not buzhuo_anim.is_playing():
		is_buzhuo = false
		buzhuo_anim.visible = false

	# 非捕捉状态才走正常动画逻辑
	if not is_buzhuo:
		if not is_on_floor():
			jump_anim.visible = true
			walk_anim.visible = false
			run_anim.visible = false
			jump_anim.play("jump")
		elif direction != 0:
			if Input.is_action_pressed("run"):
				run_anim.visible = true
				walk_anim.visible = false
				jump_anim.visible = false
				run_anim.play("run")
			else:
				walk_anim.visible = true
				run_anim.visible = false
				jump_anim.visible = false
				walk_anim.play("walk")
		else:
			walk_anim.visible = true
			run_anim.visible = false
			jump_anim.visible = false
			walk_anim.stop()

	move_and_slide()

func _process(_delta):
	if Input.is_action_just_pressed("jump") and jumps_remaining > 0 and not is_buzhuo:
		jump_trigger = true
