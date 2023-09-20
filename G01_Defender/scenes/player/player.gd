class_name Player extends Node2D

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


func _on_hitbox_component_collided():
    # disable input, physics processing, movement and collision
    set_process_unhandled_input(false)
    set_physics_process(false)
    $HitboxComponent.disable()
    $MovementComponent.disable()

    # hide the sprite
    $Sprite.visible = false

    # center the camera
    $GameCamera.center_camera()

    # play explosion particle effect and wait until it ends
    $ExplosionParticleEffect.emitting = true
    await get_tree().create_timer($ExplosionParticleEffect.lifetime).timeout

    Events.player_destroyed.emit()
