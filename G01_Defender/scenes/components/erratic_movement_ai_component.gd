class_name ErraticMovementAIComponent extends Node2D

@export var movement_component: MovementComponent = null
@export var angle := 20.0
@export var min_direction_change_time := 1.0
@export var max_direction_change_time := 2.0


func _ready():
    change_direction()


func change_direction():
    assert(movement_component != null)

    if is_zero_approx(movement_component.direction.x):
        movement_component.direction = pick_random_direction()

    assert(not is_zero_approx(movement_component.direction.x))

    var rot_angle = randf_range(-angle / 2.0, angle / 2.0)
    movement_component.direction = Vector2(sign(movement_component.direction.x), 0).rotated(deg_to_rad(rot_angle)).normalized()

    $Timer.start(randf_range(min_direction_change_time, max_direction_change_time))


func pick_random_direction() -> Vector2:
    return [Vector2.LEFT, Vector2.RIGHT].pick_random()


func _on_timer_timeout():
    change_direction()
