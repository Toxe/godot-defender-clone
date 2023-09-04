class_name HitboxComponent extends Area2D

signal destroyed()


func disable():
    set_deferred("process_mode", PROCESS_MODE_DISABLED)


func _on_area_entered(_area):
    destroyed.emit()
    get_parent().queue_free()
