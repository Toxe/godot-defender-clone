class_name Player extends Area2D

signal player_killed

const speed: float = 250


func _physics_process(delta):
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    update_horizontal_sprite_flip(direction)
    position += direction * speed * delta


func update_horizontal_sprite_flip(direction: Vector2):
    if not is_zero_approx(direction.x):
        $Sprite.scale.x = 1 if direction.x > 0 else -1


func _on_area_entered(_area):
    player_killed.emit()
