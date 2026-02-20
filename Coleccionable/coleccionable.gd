extends Area2D

func _ready() -> void:
	if has_node("ani_moneda"):
		var anim = $ani_moneda
		# Solo intenta reproducir si existe la animación
		if anim.sprite_frames.has_animation("default"):
			anim.play("default")
		else:
			# Si no hay 'default', reproduce la primera que encuentre
			var nombres = anim.sprite_frames.get_animation_names()
			if nombres.size() > 0:
				anim.play(nombres[0])

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugadores"):
		if body.has_method("add_moneda"):
			body.add_moneda()
		queue_free()
