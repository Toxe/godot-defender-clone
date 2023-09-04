class_name HitboxComponent extends Area2D

signal collided
signal destroyed

@export var destroy_parent := true


func disable():
    set_deferred("process_mode", PROCESS_MODE_DISABLED)


func _on_area_entered(_area):
    collided.emit()
    if destroy_parent:
        get_parent().queue_free()
        destroyed.emit()
