class_name LevelChunk extends Area2D

signal level_chunk_exited(level_chunk: LevelChunk, node: Node2D)


func _on_area_exited(area):
    level_chunk_exited.emit(self, area.get_parent())
