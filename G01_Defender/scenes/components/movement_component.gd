class_name MovementComponent extends Node

@export var velocity := Vector2.ZERO

func _physics_process(delta):
    get_parent().position += velocity * delta
