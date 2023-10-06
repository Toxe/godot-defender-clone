extends Enemy


func _ready():
    super()

    var height = $HitboxComponent/CollisionShape2D.shape.size.y
    $MovementComponent.clamp_position_top = height + 10
    $MovementComponent.clamp_position_bottom = get_viewport().get_visible_rect().size.y - height - 10
