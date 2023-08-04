class_name Player extends CharacterBody2D

signal player_killed

@export var speed = 250

func _physics_process(delta):
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

    update_horizontal_sprite_flip(direction)
    check_collision(move_and_collide(direction * speed * delta))


func update_horizontal_sprite_flip(direction: Vector2):
    if not is_zero_approx(direction.x):
        $Sprite.scale.x = 1 if direction.x > 0 else -1


func check_collision(collision: KinematicCollision2D):
    if collision:
        player_killed.emit()
