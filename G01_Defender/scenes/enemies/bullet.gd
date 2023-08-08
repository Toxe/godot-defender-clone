extends Area2D

const speed: float = 300
var direction := Vector2.ZERO


func setup(spawn_position: Vector2):
    global_position = spawn_position
    direction = Vector2.RIGHT.rotated(randf_range(0.0, 2 * PI))


func _physics_process(delta):
    position += direction * speed * delta


func _on_area_entered(_area):
    queue_free()


# automatically destroy when off-screen
func _on_visible_on_screen_notifier_2d_screen_exited():
    queue_free()
