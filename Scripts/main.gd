extends Control

var current_artist = null
var current_release = null

@onready var money_label = $TopBar/MoneyLabel
@onready var income_label = $TopBar/IncomeLabel
@onready var reputation_label = $TopBar/ReputationLabel

func _ready() -> void:
	$ArtistPanel/HireButton.pressed.connect(hire_artist)
	$ReleasePanel/ReleaseButton.pressed.connect(create_release)
	

# Al borrar esto las stats dejaran de ser mostradas al usuario.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	money_label.text = "Cash: $" + str(round(GameManager.money))
	income_label.text = "Income: $" + str(round(GameManager.income_per_second)) + "/sec"
	reputation_label.text = "Reputation: " + str(round(GameManager.reputation))


func hire_artist():
	var artist = {
		"name": "Maya",
		"creativity": 60,
		"technique": 45,
		"charisma": 70,
		"stress": 20,
		"loyalty": 50
	}
	
	GameManager.artists.append(artist)
	
	$ArtistPanel/ArtistName.text = artist.name
	
	$ArtistPanel/ArtistStats.text = "Creativity: %d\nTechnique: %d\nCharisma: %d\nStress: %d%%\nLoyalty %d%%" % [
		artist.creativity,
		artist.technique,
		artist.charisma,
		artist.stress,
		artist.loyalty
	]
	
	$ArtistPanel/HireButton.disabled = true
	print("Hired ", artist.name)

func create_release():
	if current_artist == null:
		$EventLog.text = "You need an artist before you can make a release!"
		return
		
	var inspiration = randf_range(0.0, 100.0) 
	
	var quality = (
		current_artist.creativity * 0.4 + current_artist.technique * 0.3 + 50.0 * 0.2 + inspiration + 0.1
	)
	
	current_release = {
		"name": "First Light",
		"quality": quality,
		"artist": current_artist.name
	}
	
	GameManager.releases.append(current_release)
	
	$ReleasePanel/SongName.text = current_release.name
	$ReleasePanel/QualityLabel.text = "Quality: " + str(round(quality)) + "%"
	
	$EventLog.text = "Released \"" + current_release.name + "\" by " + current_artist.name + "!"
