extends Panel

@export_category("Window")
@export var windowControl: WindowController

@export_category("Buttons")
@export var yesButton: Button
@export var noButton: Button

func _ready() -> void:
    # link buttons
    if !yesButton:
        push_error("missing 'yesButton'")
    if !noButton:
        push_error("missing 'noButton'")
    yesButton.pressed.connect(_on_yes_button_pressed)
    noButton.pressed.connect(_on_no_button_pressed)

func _finish_interaction() -> void:
    GlobalVariable.persistenceWarning.emit()
    windowControl._on_close_pressed()

func _on_yes_button_pressed() -> void:
    # literally nothing happens
    _finish_interaction()

func _on_no_button_pressed() -> void:
    # reset our expie data
    gbData.data["saw"] = {}
    gbData.addPet("Default")
    _finish_interaction()