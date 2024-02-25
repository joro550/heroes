extends Node2D

signal restart_pressed()

func _on_button_pressed():
	restart_pressed.emit()
