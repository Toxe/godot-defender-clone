extends Node2D

signal player_killed

const laser_scene = preload("laser.tscn")

@onready var movementComponent = $MovementComponent
@onready var player_height: float = $HitboxComponent/CollisionShape2D.shape.size.y


func _process(_delta):
    if Input.is_action_just_pressed("fire"):
        fire_laser()


func _physics_process(_delta):
    movementComponent.direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    update_horizontal_orientation(movementComponent.direction.x)
    clamp_vertical_position()


func clamp_vertical_position():
    var viewport_size = get_viewport().get_visible_rect().size
    position.y = clamp(position.y, player_height + 5, viewport_size.y - player_height - 5)


func fire_laser():
    var laser = laser_scene.instantiate()
    laser.setup($LaserSpawnPoint.global_position, get_horizontal_orientation())
    get_parent().add_child(laser)


func get_horizontal_orientation() -> float:
    return scale.x


func update_horizontal_orientation(orientation: float):
    if not is_zero_approx(orientation) and not is_equal_approx(orientation, get_horizontal_orientation()):
        scale.x = 1.0 if orientation > 0.0 else -1.0


# wrap around to the other side of the level
func wrap_around_level(node: Node2D):
    if node.global_position.x < global_position.x:
        node.position.x += 3*1152
    else:
        node.position.x -= 3*1152


func _on_hitbox_component_destroyed():
    player_killed.emit()


func _on_wrap_enemies_area_exited(area: Area2D):
    wrap_around_level(area.get_parent())


func _on_wrap_level_chunks_area_exited(area: Area2D):
    wrap_around_level(area)
