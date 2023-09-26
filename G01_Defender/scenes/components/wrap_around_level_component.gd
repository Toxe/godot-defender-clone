class_name WrapAroundLevelComponent extends Node

enum WrapAroundSide {
    left = -1,
    right = 1
}


func _ready():
    var world = get_parent() as World

    if world:
        assert(world.get_ordered_level_chunks().size() >= 3)

        for chunk in world.get_ordered_level_chunks():
            chunk.level_chunk_exited.connect(_on_level_chunk_exited)


func number_of_level_chunks_in_front_of_player(total_number_of_level_chunks: int) -> int:
    return ceili((total_number_of_level_chunks - 1) / 2.0)


func wrap_node_around_level(node: Node2D, wrap_to_side: WrapAroundSide, number_of_level_chunks: int, level_chunk_width: int):
    node.global_position.x += number_of_level_chunks * level_chunk_width * int(wrap_to_side)


func wrap_chunks_around_level(level_chunks: Array[Node], begin_index: int, end_index: int, wrap_to_side: WrapAroundSide):
    for i in range(begin_index, end_index):
        wrap_node_around_level(level_chunks[i], wrap_to_side, level_chunks.size(), 1152)


func _on_level_chunk_exited(level_chunk: LevelChunk, node: Node2D):
    var world = get_parent() as World
    var level_chunks = world.get_ordered_level_chunks()

    if node is Player:
        var chunk_exited_index := level_chunks.find(level_chunk)
        assert(chunk_exited_index >= 0)

        if node.global_position.x < level_chunk.global_position.x:
            # wrap to left side
            var chunk_index := chunk_exited_index - 1
            var number_of_chunks_to_wrap = number_of_level_chunks_in_front_of_player(level_chunks.size()) - chunk_index

            if number_of_chunks_to_wrap > 0:
                wrap_chunks_around_level(level_chunks, level_chunks.size() - number_of_chunks_to_wrap, level_chunks.size(), WrapAroundSide.left)
        elif node.global_position.x > level_chunk.global_position.x + 1152:
            # wrap to right side
            var chunk_index := chunk_exited_index + 1
            var number_of_chunks_to_wrap = number_of_level_chunks_in_front_of_player(level_chunks.size()) - (level_chunks.size() - chunk_index) + 1

            if number_of_chunks_to_wrap > 0:
                wrap_chunks_around_level(level_chunks, 0, number_of_chunks_to_wrap, WrapAroundSide.right)
    else:
        if node.global_position.x < level_chunks.front().global_position.x:
            wrap_node_around_level(node, WrapAroundSide.right, level_chunks.size(), 1152)
        elif node.global_position.x > level_chunks.back().global_position.x + 1152:
            wrap_node_around_level(node, WrapAroundSide.left, level_chunks.size(), 1152)
