class_name Enemy extends Node2D

@export var score := 0
@export var type := Enums.EnemyType.unknown


static func collect_existing_enemies(scene_tree: SceneTree) -> Array[Enemy]:
    var enemies: Array[Enemy] = []
    for enemy in scene_tree.get_nodes_in_group("enemies"):
        if not enemy.is_queued_for_deletion():
            enemies.append(enemy)
    return enemies


func _ready() -> void:
    add_to_group("enemies")

    # automatically connect to the HitboxComponent "destroyed" signal
    for child in get_children():
        var hitbox_component := child as HitboxComponent
        if hitbox_component:
            hitbox_component.destroyed.connect(_on_destroyed)
            break


func _on_destroyed() -> void:
    Events.enemy_destroyed.emit(self)
