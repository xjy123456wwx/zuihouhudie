extends Node

@export var room_list: Array

func _ready():
	for room in room_list:
		room.visible = false
		room.process_mode = Node.PROCESS_MODE_DISABLED
	if room_list.size():
		room_list[0].visible = true
		room_list[0].process_mode = Node.PROCESS_MODE_INHERIT

func switch_room(target_room:Node2D):
	for room in room_list:
		room.visible = false
		room.process_mode = Node.PROCESS_MODE_DISABLED
	target_room.visible = true
	target_room.process_mode = Node.PROCESS_MODE_INHERIT
	
