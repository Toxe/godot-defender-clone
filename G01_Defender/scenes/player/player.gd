extends Area2D

signal player_killed

const laser_scene = preload("res://scenes/player/laser.tscn")
const speed: float = 250


func _process(_delta):
    if Input.is_action_just_pressed("fire"):
        fire_laser()


func _physics_process(delta):
    var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    update_horizontal_orientation(direction.x)
    position += direction * speed * delta


func fire_laser():
    var laser = laser_scene.instantiate()
    laser.setup(global_position, get_horizontal_orientation())
    get_parent().add_child(laser)


func get_horizontal_orientation() -> float:
    return scale.x


func update_horizontal_orientation(orientation: float):
    if not is_zero_approx(orientation) and not is_equal_approx(orientation, get_horizontal_orientation()):
        scale.x = 1.0 if orientation > 0.0 else -1.0


func _on_area_entered(_area):
    player_killed.emit()
