extends CharacterBody2D

const gravity = 2000
const speed_walk = 300   # 走路速度
const speed_run = 550    # 跑步速度
const jump_force = 800

var max_jumps = 2
var jumps_remaining = max_jumps

@onready var walk_anim = $walkAnimatedSprite2D
@onready var jump_anim = $jumpAnimatedSprite2D
@onready var run_anim = $runAnimatedSprite2D

var jump_trigger = false

func _physics_process(delta):
	# 重力逻辑
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		jumps_remaining = max_jumps

	# 方向输入
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	# ======================================
	# 【速度逻辑：按住Shift(run)跑步，不按走路】
	# 对应你输入映射里的 run = Shift键
	# ======================================
	if Input.is_action_pressed("run"):
		velocity.x = direction * speed_run
	else:
		velocity.x = direction * speed_walk

	# 跳跃核心修复（平地能跳+二段跳）
	if jump_trigger:
		jump_trigger = false
		velocity.y = -jump_force
		jumps_remaining -= 1

	# 左右翻转全部动画
	if direction != 0:
		walk_anim.flip_h = direction < 0
		jump_anim.flip_h = direction < 0
		run_anim.flip_h = direction < 0

	# ======================================
	# 【动画逻辑：走路/跑步/跳跃自动切换+自动隐藏其他动画】
	# ======================================
	if not is_on_floor():
		# 在空中：只显示跳跃动画
		jump_anim.visible = true
		walk_anim.visible = false
		run_anim.visible = false
		jump_anim.play("jump")
	elif direction != 0:
		if Input.is_action_pressed("run"):
			# 按住Shift → 跑步动画
			run_anim.visible = true
			walk_anim.visible = false
			jump_anim.visible = false
			run_anim.play("run")
		else:
			# 只按方向键 → 走路动画
			walk_anim.visible = true
			run_anim.visible = false
			jump_anim.visible = false
			walk_anim.play("walk")
	else:
		# 站着不动 → 待机动画
		walk_anim.visible = true
		run_anim.visible = false
		jump_anim.visible = false
		walk_anim.play("walk")

	move_and_slide()

# 纯键盘跳跃检测，永不报错
func _process(_delta):
	if Input.is_action_just_pressed("jump") and jumps_remaining > 0:
		jump_trigger = true
