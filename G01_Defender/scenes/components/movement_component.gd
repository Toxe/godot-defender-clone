class_name MovementComponent extends Node

@export var speed := 0.0:
    get:
        return speed
    set(value):
        speed = value
        velocity_ = direction.normalized() * speed

@export var direction := Vector2.ZERO:
    get:
        return direction
    set(value):
        direction = value
        velocity_ = direction.normalized() * speed

@onready var velocity_: Vector2 = direction.normalized() * speed


func _physics_process(delta):
    get_parent().position += velocity_ * delta


# set velocity and automatically update speed and direction
func set_velocity(new_velocity: Vector2):
    direction = new_velocity.normalized()
    speed = new_velocity.length()
