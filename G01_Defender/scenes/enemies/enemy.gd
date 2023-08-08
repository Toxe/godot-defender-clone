extends Area2D

const bullet_scene = preload("bullet.tscn")
const speed: float = 50
var direction := Vector2(-1, 0.3).normalized()


func _ready():
    $ShootTimer.start(randf_range(1, 3))


func _physics_process(delta):
    position += direction * speed * delta


func shoot_bullet():
    var bullet = bullet_scene.instantiate()
    bullet.setup(global_position)
    get_parent().add_child(bullet)
    $ShootTimer.start(randf_range(3, 5))


func _on_area_entered(_area):
    queue_free()


func _on_shoot_timer_timeout():
    shoot_bullet()
