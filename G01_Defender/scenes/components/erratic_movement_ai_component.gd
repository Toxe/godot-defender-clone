class_name ErraticMovementAIComponent extends Node2D

@export var movement_component: MovementComponent = null
@export var angle := 20.0
@export var min_direction_change_time := 1.0
@export var max_direction_change_time := 2.0


func _ready():
    change_direction()


func _draw():
    const width = 2
    var length = movement_component.speed
    var add_angle = 180.0 if movement_component.direction.x < 0 else 0.0
    draw_arc(Vector2.ZERO, length, deg_to_rad(angle + add_angle), deg_to_rad(-angle + add_angle), 10, Color.DIM_GRAY, width)
    draw_line(Vector2.ZERO, length * Vector2.RIGHT.rotated(deg_to_rad(angle + add_angle)), Color.DIM_GRAY, width)
    draw_line(Vector2.ZERO, length * Vector2.RIGHT.rotated(deg_to_rad(-angle + add_angle)), Color.DIM_GRAY, width)
    draw_line(Vector2.ZERO, length * movement_component.velocity_.normalized(), Color.YELLOW, width)


func change_direction():
    assert(movement_component != null)

    if is_zero_approx(movement_component.direction.x):
        movement_component.direction = pick_random_direction()

    assert(not is_zero_approx(movement_component.direction.x))

    var rot_angle = randf_range(-angle, angle)
    movement_component.direction = Vector2(sign(movement_component.direction.x), 0).rotated(deg_to_rad(rot_angle)).normalized()

    $Timer.start(randf_range(min_direction_change_time, max_direction_change_time))
    queue_redraw()


func pick_random_direction() -> Vector2:
    return [Vector2.LEFT, Vector2.RIGHT].pick_random()


func _on_timer_timeout():
    change_direction()
