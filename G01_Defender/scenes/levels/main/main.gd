class_name MainLevel extends Node

const world_scene = preload("res://scenes/levels/main/world/world.tscn")

var _world: World = null


func _ready():
    Events.player_destroyed.connect(_on_player_destroyed)
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
    $SpawnWaves.start_timer_to_spawn_immediate_wave()


func _on_player_destroyed():
    if $LivesCounter.has_lives_left():
        $LivesCounter.decrease()
        await start_level()
    else:
        # show game over text, wait for a moment and then finish the game
        $UI/GameOverLabel.visible = true
        await get_tree().create_timer(1.5).timeout
        Events.game_finished.emit($ScoreCounter.score)
