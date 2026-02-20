extends Control

func actualizar(monedas: int) -> void:
	# Primero verificamos si el nodo existe antes de cambiar el texto
	if has_node("hbox/lbl_contador"):
		$hbox/lbl_contador.text = str(monedas)
	else:
		print("Error: No se encuentra el nodo lbl_contador en la ruta especificada")
