class_name MovementComponent extends Node

@export var speed := 0.0:
    get:
        return speed
    set(value):
        speed = value
        _velocity = direction.normalized() * speed

@export var direction := Vector2.ZERO:
    get:
        return direction
    set(value):
        direction = value
        _velocity = direction.normalized() * speed

@onready var _velocity: Vector2 = direction.normalized() * speed


func _physics_process(delta):
    get_parent().position += _velocity * delta


func velocity() -> Vector2:
    return _velocity


# set velocity and automatically update speed and direction
func set_velocity(new_velocity: Vector2):
    direction = new_velocity.normalized()
    speed = new_velocity.length()
