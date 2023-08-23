extends Node2D

func setup(spawn_position: Vector2):
    global_position = spawn_position
    $MovementComponent.direction = Vector2.RIGHT.rotated(randf_range(0.0, 2 * PI))
