extends Node

signal terminalOpenPressed

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("Open Terminal"):
        terminalOpenPressed.emit()