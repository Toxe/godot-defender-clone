class_name LifetimeComponent extends Node

signal destroyed()

@export var visible_on_screen_notifier: VisibleOnScreenNotifier2D = null
@export var lifetime := 0.0


func _ready():
    if visible_on_screen_notifier:
        visible_on_screen_notifier.connect("screen_exited", _on_screen_exited)
    if not is_zero_approx(lifetime):
        $Timer.start(lifetime)


func _on_screen_exited():
    destroy()


func _on_timer_timeout():
    destroy()


func destroy():
    destroyed.emit()
    get_parent().queue_free()
