class_name FlipOrientationComponent extends Node

enum Orientation {
    unknown,
    left,
    right
}

@export var movement_component: MovementComponent = null

var orientation := Orientation.unknown


func _ready():
    update_orientation(get_orientation_from_movement())


func _physics_process(_delta):
    update_orientation(get_orientation_from_movement())


func get_orientation_from_movement() -> FlipOrientationComponent.Orientation:
    # return the current orientation if the object is not moving
    if is_zero_approx(movement_component.direction.x):
        return orientation
    return Orientation.left if movement_component.direction.x < 0.0 else Orientation.right


func update_orientation(new_orientation: FlipOrientationComponent.Orientation):
    if new_orientation != orientation:
        var parent = get_parent() as Node2D
        orientation = new_orientation
        parent.scale.x = -1.0 if orientation == Orientation.left else 1.0
