extends Node


var money: float = 5000.0
var reputation: float = 25.0

var income_per_second: float = 0

var artists: Array = []
var releases: Array = []


func _process(delta: float) -> void:
	money += income_per_second * delta
