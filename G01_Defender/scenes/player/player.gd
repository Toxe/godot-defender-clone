extends Node2D

signal player_killed

const laser_scene = preload("laser.tscn")

@onready var movementComponent = $MovementComponent
@onready var player_height: float = $HitboxComponent/CollisionShape2D.shape.size.y


func _unhandled_input(event):
    if event.is_action_pressed("fire"):
        fire_laser()
        get_viewport().set_input_as_handled()


func _physics_process(_delta):
    movementComponent.direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    clamp_vertical_position()


func clamp_vertical_position():
    var viewport_size = get_viewport().get_visible_rect().size
    position.y = clamp(position.y, player_height + 5, viewport_size.y - player_height - 5)


func fire_laser():
    var direction = Vector2.LEFT if $FlipOrientationComponent.orientation == FlipOrientationComponent.Orientation.left else Vector2.RIGHT
    $ShootingComponent.shoot(direction)


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
