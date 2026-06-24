extends Node2D

@export var player: CharacterBody2D
@export var area_room4: Area2D
@export var area_room6: Area2D

var mask4: ColorRect = null
var mask6: ColorRect = null
var always_black_list: Array[ColorRect] = []

func _ready():
	# 遍历子节点，只识别 MaskRoom4、MaskRoom6 和固定黑块
	for child in get_children():
		if child is ColorRect:
			match child.name:
				"MaskRoom4":
					mask4 = child
				"MaskRoom6":
					mask6 = child
				_:
					always_black_list.append(child)
	
	# 初始化：所有固定黑块和 Mask4/Mask6 都设为不透明（全黑）
	for m in always_black_list:
		m.modulate.a = 1.0
	if mask4:
		mask4.modulate.a = 1.0
	if mask6:
		mask6.modulate.a = 1.0

func _process(_delta):
	# 检测玩家是否在 Room4 / Room6 区域
	var in_room4 = area_room4 != null and area_room4.overlaps_body(player)
	var in_room6 = area_room6 != null and area_room6.overlaps_body(player)

	# 控制 MaskRoom4 透明度：在 Room4 → 透明；不在 → 全黑
	if mask4:
		mask4.modulate.a = 0.0 if in_room4 else 1.0
	# 控制 MaskRoom6 透明度：在 Room6 → 透明；不在 → 全黑
	if mask6:
		mask6.modulate.a = 0.0 if in_room6 else 1.0
		
