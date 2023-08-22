extends Area2D

func setup(spawn_position: Vector2, orientation: float):
    global_position = spawn_position
    $MovementComponent.direction = Vector2.RIGHT * orientation
    scale.x = orientation


func _on_area_entered(_area):
    queue_free()
