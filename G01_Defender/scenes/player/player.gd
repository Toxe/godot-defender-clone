class_name Player extends Node2D

const laser_scene = preload("laser.tscn")

@onready var speed: float = $MovementComponent.speed


func _ready() -> void:
    var height: float = $HitboxComponent/CollisionShape2D.shape.size.y
    $MovementComponent.clamp_position_top = height + 5
    $MovementComponent.clamp_position_bottom = get_viewport().get_visible_rect().size.y - height - 5


func _unhandled_input(event: InputEvent) -> void:
    if event.is_action_pressed("fire"):
        fire_laser()
        get_viewport().set_input_as_handled()


func _physics_process(_delta: float) -> void:
    # don't normalize player velocity; flying diagonally doesn't reduce horizontal speed
    var h := Input.get_axis("move_left", "move_right")
    var v := Input.get_axis("move_up", "move_down")
    $MovementComponent.set_velocity(Vector2(h * speed, v * speed))


func fire_laser() -> void:
    var direction := Vector2.LEFT if $FlipOrientationComponent.orientation == FlipOrientationComponent.Orientation.left else Vector2.RIGHT
    $ShootingComponent.shoot(direction)


func _on_hitbox_component_collided() -> void:
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
