class_name ShootingComponent extends Node2D

signal shot_fired

@export var shot_scene: PackedScene = null
@export var visible_on_screen_notifier: VisibleOnScreenNotifier2D = null
@export var shooting_ai_component: Node = null
@export var min_shot_delay := 1.0
@export var max_shot_delay := 2.0
@export var one_shot := false


func _ready():
    if visible_on_screen_notifier:
        visible_on_screen_notifier.connect("screen_entered", start_shooting)
        visible_on_screen_notifier.connect("screen_exited", stop_shooting)


func start_shooting():
    if not one_shot:
        $Timer.start(randf_range(min_shot_delay, max_shot_delay))


func stop_shooting():
    $Timer.stop()


func shoot(direction: Vector2 = Vector2.ZERO) -> Node2D:
    var shot = shot_scene.instantiate() as Node2D
    shot.global_position = global_position

    if shot.has_node("MovementComponent"):
        var shot_movement_component = shot.get_node("MovementComponent") as MovementComponent
        shot_movement_component.direction = direction

    if shooting_ai_component:
        shooting_ai_component.update(shot, global_position)  # note: shot is not yet in the tree so shot.global_position is still (0,0) at this point

    get_parent().get_parent().add_child(shot)
    start_shooting()
    shot_fired.emit()

    return shot


func _on_timer_timeout():
    shoot()
