class_name MainLevel extends Node

const world_scene = preload("res://scenes/levels/main/world/world.tscn")

var _world: World = null


func _ready():
    Events.player_destroyed.connect(_on_player_destroyed)
    Events.level_completed.connect(_on_level_completed)
    await start_level()


func unload_world():
    if _world:
        var num_children = get_child_count()
        _world.queue_free()
        _world = null
        while get_child_count() == num_children:
            await get_tree().process_frame


func load_world():
    _world = world_scene.instantiate() as World
    add_child(_world)


func start_level():
    await unload_world()
    load_world()


func _on_player_destroyed():
    if $LivesCounter.has_lives_left():
        # decrease player lives and respawn
        $LivesCounter.decrease()
        await start_level()
    else:
        # show "game over" text, wait a moment and then finish the game
        $UI/GameOverLabel.visible = true
        await get_tree().create_timer(1.5).timeout
        $UI/GameOverLabel.visible = false
        Events.game_finished.emit($ScoreCounter.score)


func _on_level_completed():
    # show "level completed" text, wait a moment and then start a new level
    $UI/LevelCompletedLabel.text = "LEVEL XX COMPLETED"
    $UI/LevelCompletedLabel.visible = true
    await unload_world()
    await get_tree().create_timer(1.5).timeout
    $UI/LevelCompletedLabel.visible = false
    await start_level()
