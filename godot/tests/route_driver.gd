extends RefCounted
## Scripted route through the extended firefighter level:
## approach + climb + dog detour (drop -> reach dog -> jump back) + window finish.
## No position/velocity edits — only inputs, like a player would give.
var right_marks: Array[float] = [138.0, 292.0, 424.0, 548.0, 712.0, 955.0, 1052.0, 1230.0, 1348.0, 1486.0]
var next_jump: int = 0
var phase: int = 0  # 0 climb-right, 1 go-to-dog, 2 return-jump, 3 walk-to-window
var returned: bool = false

func step(player: CharacterBody2D) -> void:
	player.test_control = true
	player.test_jump_held = false
	if phase == 0:
		# Run right through the approach + climb, jumping at each mark on the ground.
		player.test_axis = 1.0
		if next_jump < right_marks.size() and player.position.x >= right_marks[next_jump] and player.is_on_floor():
			player.test_jump_pressed = true
			next_jump += 1
		elif next_jump >= right_marks.size() and player.is_on_floor() and player.position.x > 1560.0 and player.position.y < 150.0:
			phase = 1  # landed on the top floor (P5)
	elif phase == 1:
		# Walk right off P5, drop onto the ledge, reach the dog.
		player.test_axis = 1.0
		if player.is_on_floor() and player.position.y > 150.0 and player.position.x >= 1795.0:
			phase = 2
	elif phase == 2:
		# Head back: jump left off the ledge, back up onto P5.
		player.test_axis = -1.0
		if player.is_on_floor() and player.position.y > 150.0 and not returned:
			player.test_jump_pressed = true
			returned = true
		elif player.is_on_floor() and player.position.y < 150.0 and returned:
			phase = 3
	else:
		# Walk left along P5 to the window.
		player.test_axis = -1.0
