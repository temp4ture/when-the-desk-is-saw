
extends Node

class Locale:
    var name: String
    var root_path: String

var locales: Array[Locale]

var _has_fetched_locales: bool = false

## Search through and register all locales.
func fetchLocales() -> void:
    pass

## Apply a locale via it's name
func applyLocale(which: String) -> void:
    pass

func _ready() -> void:
    print(OS.get_locale())