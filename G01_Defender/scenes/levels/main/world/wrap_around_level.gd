extends Node

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


func wrap_node_around_level(node: Node2D, wrap_to_side: WrapAroundSide, level_width: float):
    node.global_position.x += level_width * int(wrap_to_side)


func wrap_chunks_around_level(level_chunks: Array[LevelChunk], begin_index: int, end_index: int, wrap_to_side: WrapAroundSide, level_width: float):
    for i in range(begin_index, end_index):
        wrap_node_around_level(level_chunks[i], wrap_to_side, level_width)


func calc_level_width(level_chunks: Array[LevelChunk]) -> float:
    return level_chunks.size() * level_chunks.front().width


func _on_level_chunk_exited(level_chunk: LevelChunk, node: Node2D):
    var world = get_parent() as World
    var level_chunks := world.get_ordered_level_chunks()
    var level_width := calc_level_width(level_chunks)

    if node is Player:
        var chunk_exited_index := level_chunks.find(level_chunk)
        assert(chunk_exited_index >= 0)

        if node.global_position.x < level_chunk.global_position.x:
            # wrap to left side
            var chunk_index := chunk_exited_index - 1
            var number_of_chunks_to_wrap = number_of_level_chunks_in_front_of_player(level_chunks.size()) - chunk_index

            if number_of_chunks_to_wrap > 0:
                wrap_chunks_around_level(level_chunks, level_chunks.size() - number_of_chunks_to_wrap, level_chunks.size(), WrapAroundSide.left, level_width)
        elif node.global_position.x > level_chunk.global_position.x + level_chunk.width:
            # wrap to right side
            var chunk_index := chunk_exited_index + 1
            var number_of_chunks_to_wrap = number_of_level_chunks_in_front_of_player(level_chunks.size()) - (level_chunks.size() - chunk_index) + 1

            if number_of_chunks_to_wrap > 0:
                wrap_chunks_around_level(level_chunks, 0, number_of_chunks_to_wrap, WrapAroundSide.right, level_width)
    else:
        if node.global_position.x < level_chunks.front().global_position.x:
            wrap_node_around_level(node, WrapAroundSide.right, level_width)
        elif node.global_position.x > level_chunks.back().global_position.x + level_chunks.back().width:
            wrap_node_around_level(node, WrapAroundSide.left, level_width)
