class_name Enemy extends Node2D

@export var score := 0


func _ready():
    # automatically connect to the HitboxComponent "destroyed" signal
    for child in get_children():
        var hitbox_component = child as HitboxComponent
        if hitbox_component:
            hitbox_component.destroyed.connect(_on_destroyed)
            break


func _on_destroyed():
    Events.enemy_destroyed.emit(self)
