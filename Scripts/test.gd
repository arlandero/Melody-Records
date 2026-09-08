extends Node2D

var MPC = 1
var value = 30
var multi = 2
var money = 0
var pressedBefore = false
@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	$Label.text = "your money: " + str(money)
	$Button3.text = "TO UPGRADE YOUR CLICKS X2 CLICK HERE COSTS " + str(value) + " MONEY"

func _on_button_pressed() -> void:
	money += MPC

func _on_button_2_pressed() -> void:
	if money >= 20 and pressedBefore == false:
		money -= 20
		$Timer.start()
		pressedBefore = true
	if money >= 20:
		multi += 2
		money -= 20

func _on_timer_timeout() -> void:
	money += 1 * multi

func _on_button_3_pressed() -> void:
	if money >= value:
		MPC *= 2
		money -= 30
		value *= 2


func _on_button_4_pressed() -> void:
	money += 20
