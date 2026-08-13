@tool
class_name ConfigCheckbox
extends PanelContainer

@export_category("Checkbox Settings")

## Text to be shown alongside the checkbox.
@export var label: String:
	set(new_label):
		label = new_label
		_update_label()
## Config. key to change when switching the checkbox.
@export var key: String

@export var _checkbox: CheckBox
@export var _label: RichTextLabel

func _update_label() -> void:
	# this function is called before the label can ready up, which is
	# prettyy annoying. couldn't find a proper way to call this once.
	if not _label:
		return
	_label.text = label

func _ready() -> void:
	_update_label()

func _on_check_box_toggled(toggled: bool) -> void:
	gbData.settings.set(key, toggled)
	print("Setting '%s' [%s] set to '%s'" % [label, key, toggled])
