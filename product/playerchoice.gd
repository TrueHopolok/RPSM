extends TextureButton

signal just_pressed(node)

func _pressed():
	just_pressed.emit(self)
