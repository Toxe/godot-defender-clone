class_name ShootingComponent extends Node2D

signal shot_fired

@export var shot_scene: PackedScene = null
@export var visible_on_screen_notifier: VisibleOnScreenNotifier2D = null
@export var min_shot_delay := 1.0
@export var max_shot_delay := 2.0


func _ready():
    if visible_on_screen_notifier:
        visible_on_screen_notifier.connect("screen_entered", start_shooting)
        visible_on_screen_notifier.connect("screen_exited", stop_shooting)


func start_shooting():
    $Timer.start(randf_range(min_shot_delay, max_shot_delay))


func stop_shooting():
    $Timer.stop()


func shoot():
    var shot = shot_scene.instantiate()
    shot.setup(global_position)
    get_parent().get_parent().add_child(shot)
    start_shooting()
    shot_fired.emit()


func _on_timer_timeout():
    shoot()
