class_name HitboxComponent extends Area2D

signal destroyed()


func _on_area_entered(_area):
    destroyed.emit()
    get_parent().queue_free()
