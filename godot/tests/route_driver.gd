extends RefCounted
## Scripted LINEAR route through the two-building level:
## approach -> climb B1 (rescue person) -> walk off + drop to B1-ground -> jump the
## burning street -> climb B2 (rescue dog) -> B2 rooftop exit.
## No position/velocity edits — only inputs, like a player would give. The descent is a
## plain walk-off-the-ledge (no jump mark), so move-right handles it.
var right_marks: Array[float] = [138.0, 292.0, 424.0, 548.0, 712.0, 955.0, 1010.0, 1112.0, 1385.0, 1480.0, 1582.0, 1755.0, 1842.0]
var next_jump: int = 0

func step(player: CharacterBody2D) -> void:
	player.test_control = true
	player.test_axis = 1.0
	player.test_jump_held = false
	if next_jump < right_marks.size() and player.position.x >= right_marks[next_jump] and player.is_on_floor():
		player.test_jump_pressed = true
		next_jump += 1
