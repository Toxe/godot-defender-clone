class_name Player extends Area2D

signal player_killed

const speed: float = 250


func _physics_process(delta):
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    update_horizontal_orientation(direction.x)
    position += direction * speed * delta


func get_horizontal_orientation() -> float:
    return scale.x


func update_horizontal_orientation(orientation: float):
    if not is_zero_approx(orientation) and not is_equal_approx(orientation, get_horizontal_orientation()):
        scale.x = 1.0 if orientation > 0.0 else -1.0


func _on_area_entered(_area):
    player_killed.emit()
