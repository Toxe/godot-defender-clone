class_name MovementComponent extends Node

@export var can_wrap_around_vertically := false
@export var can_clamp_vertical_position := false
@export var clamp_position_top := 0.0
@export var clamp_position_bottom := 0.0

@export var speed := 0.0:
    set(value):
        speed = value
        _velocity = direction.normalized() * speed

@export var direction := Vector2.ZERO:
    set(value):
        direction = value
        _velocity = direction.normalized() * speed

@onready var _velocity: Vector2 = direction.normalized() * speed


func _physics_process(delta: float) -> void:
    var pos: Vector2 = get_parent().position + _velocity * delta
    if can_clamp_vertical_position:
        pos = clamp_vertical_position(pos)
    if can_wrap_around_vertically:
        pos = vertical_wrap_around(pos)
    get_parent().position = pos


func clamp_vertical_position(pos: Vector2) -> Vector2:
    return Vector2(pos.x, clamp(pos.y, clamp_position_top, clamp_position_bottom))


func vertical_wrap_around(pos: Vector2) -> Vector2:
    var viewport_size := get_viewport().get_visible_rect().size
    if pos.y < 0:
        pos.y += viewport_size.y
    elif pos.y >= viewport_size.y:
        pos.y -= viewport_size.y
    return pos


func velocity() -> Vector2:
    return _velocity


# set velocity and automatically update speed and direction
func set_velocity(new_velocity: Vector2) -> void:
    direction = new_velocity.normalized()
    speed = new_velocity.length()


func disable() -> void:
    set_physics_process(false)
