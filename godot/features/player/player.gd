extends CharacterBody2D

const Tuning = preload("res://features/player/tuning.gd")
var tuning = Tuning.new()
var enabled: bool = false
var tick: int = 0
var last_floor_tick: int = -1000
var jump_request_tick: int = -1000
var opportunity_consumed: bool = false
var require_jump_release: bool = true
var facing: float = 1.0
var jumps: int = 0
var test_control: bool = false
var test_axis: float = 0.0
var test_jump_pressed: bool = false
var test_jump_held: bool = false

func _ready() -> void:
	name = "Player"
	collision_layer = 2
	collision_mask = 1
	floor_snap_length = 1.0
	var shape := RectangleShape2D.new()
	shape.size = Vector2(18, 28)
	var collider := CollisionShape2D.new()
	collider.shape = shape
	collider.position = Vector2(0, -14)
	add_child(collider)

func reset_at(spawn: Vector2) -> void:
	position = spawn
	velocity = Vector2.ZERO
	last_floor_tick = -1000
	jump_request_tick = -1000
	opportunity_consumed = false
	require_jump_release = true
	test_jump_pressed = false
	jumps = 0
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not enabled:
		return
	tick += 1
	var axis := test_axis if test_control else Input.get_axis("move_left", "move_right")
	var held := test_jump_held if test_control else Input.is_action_pressed("jump")
	var pressed := test_jump_pressed if test_control else Input.is_action_just_pressed("jump")
	test_jump_pressed = false
	if not held:
		require_jump_release = false
	if is_on_floor() and velocity.y >= 0.0:
		last_floor_tick = tick
		opportunity_consumed = false
	if pressed and not require_jump_release:
		jump_request_tick = tick
	var rate: float = tuning.acceleration if not is_zero_approx(axis) else tuning.deceleration
	velocity.x = move_toward(velocity.x, axis * tuning.speed, rate * delta)
	if not is_zero_approx(axis):
		facing = signf(axis)
	velocity.y = minf(velocity.y + tuning.gravity * delta, tuning.terminal_velocity)
	if not opportunity_consumed and tick - last_floor_tick <= tuning.coyote_ticks and tick - jump_request_tick <= tuning.buffer_ticks:
		velocity.y = tuning.jump_velocity
		opportunity_consumed = true
		jump_request_tick = -1000
		jumps += 1
	move_and_slide()
	position.x = maxf(position.x, 10.0)
	queue_redraw()

func _draw() -> void:
	# Postman ("Postman's Rush"). Original geometric drawing — no imported art.
	# Collider (18x28) and movement are unchanged; this is a pure repaint.
	var uniform := Color("2f6db0")   # postal-blue shirt
	var trouser := Color("22314a")   # navy trousers + cap
	var ink := Color("1b2a3f")       # outline
	var skin := Color("e8b98f")      # face
	var bag_col := Color("a9743f")   # brown mailbag
	var flap := Color("7d5227")      # bag flap + strap + belt
	var gold := Color("f2c94c")      # cap badge + buckle
	var f := facing                  # +1 right, -1 left
	var stride := sin(float(tick) * 0.7) * 2.0 if is_on_floor() and absf(velocity.x) > 8 else 0.0
	# legs (navy) to the feet, waddle when walking
	draw_rect(Rect2(-5, -4, 3, 4 + stride), trouser)
	draw_rect(Rect2(2, -4, 3, 4 - stride), trouser)
	# body: outline, blue shirt, navy trousers, belt
	draw_rect(Rect2(-9, -19, 18, 15), ink)
	draw_rect(Rect2(-7, -17, 14, 7), uniform)
	draw_rect(Rect2(-7, -10, 14, 6), trouser)
	draw_rect(Rect2(-8, -11, 16, 2), flap)
	# strap across chest (front shoulder -> back hip)
	draw_line(Vector2(5.0 * f, -17), Vector2(-6.0 * f, -10), flap, 2.0)
	# mailbag on the back hip (mirrors with facing)
	var bag_left := -12.0 if f > 0 else 5.0
	draw_rect(Rect2(bag_left - 1.0, -14, 9, 10), ink)
	draw_rect(Rect2(bag_left, -13, 7, 8), bag_col)
	draw_rect(Rect2(bag_left, -13, 7, 3), flap)
	draw_rect(Rect2(bag_left + 3.0, -11, 1, 2), gold)
	# head (skin) with outline
	draw_rect(Rect2(-6, -26, 12, 8), ink)
	draw_rect(Rect2(-5, -25, 10, 6), skin)
	# cap: crown + forward brim + gold badge (brim mirrors with facing)
	draw_rect(Rect2(-7, -30, 14, 6), ink)
	draw_rect(Rect2(-6, -29, 12, 5), trouser)
	var brim_x := -1.0 if f > 0 else -10.0
	draw_rect(Rect2(brim_x, -24, 11, 2), trouser)
	draw_rect(Rect2(-2, -27, 4, 2), gold)
	# eye on the front of the face
	draw_circle(Vector2(2.5 * f, -22), 1.2, ink)
