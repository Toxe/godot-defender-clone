class_name RepeatShootingComponent extends Node2D

@export var shooting_component: ShootingComponent = null
@export var visible_on_screen_notifier: VisibleOnScreenNotifier2D = null
@export var min_repeat_delay := 1.0
@export var max_repeat_delay := 2.0
@export var min_number_of_repetitions := 2
@export var max_number_of_repetitions := 4

var remaining_shots := 0


func _ready() -> void:
    if visible_on_screen_notifier:
        visible_on_screen_notifier.connect("screen_entered", start)
        visible_on_screen_notifier.connect("screen_exited", stop)
    if shooting_component:
        shooting_component.connect("shot_fired", _on_shot_fired)


func start() -> void:
    $Timer.start(randf_range(min_repeat_delay, max_repeat_delay))


func stop() -> void:
    $Timer.stop()
    if shooting_component:
        shooting_component.stop_shooting()


func _on_timer_timeout() -> void:
    if shooting_component:
        remaining_shots = randi_range(min_number_of_repetitions, max_number_of_repetitions)
        shooting_component.start_shooting()


func _on_shot_fired() -> void:
    remaining_shots -= 1
    if remaining_shots == 0:
        stop()
        start()
