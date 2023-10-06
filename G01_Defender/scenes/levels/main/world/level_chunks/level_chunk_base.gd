class_name LevelChunk extends Area2D

signal level_chunk_exited(level_chunk: LevelChunk, node: Node2D)


var size: Vector2:
    get: return $CollisionShape2D.shape.size


var width: float:
    get: return size.x


var height: float:
    get: return size.y


func _on_area_exited(area):
    level_chunk_exited.emit(self, area.get_parent())
