extends Node2D

signal play_pressed()

func _on_button_pressed():
	play_pressed.emit()
