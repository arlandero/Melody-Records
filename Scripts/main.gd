extends Control

var current_artist = null
var current_release = null
var release_ready = null

@onready var money_label = $TopBar/MoneyLabel
@onready var income_label = $TopBar/IncomeLabel
@onready var reputation_label = $TopBar/ReputationLabel
# Esto conecta los botones, por ahora funciona pero se puede hacer de una forma mas limpia.
func _ready() -> void:
	$ArtistPanel/HireButton.pressed.connect(hire_artist)
	$ReleasePanel/ReleaseButton.pressed.connect(create_release)
	$ReleasePanel/ReleaseButton.disabled = true
	$ReleasePanel/CreateSongButton.pressed.connect(create_song)

# Al borrar esto las stats dejaran de ser mostradas al usuario.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	money_label.text = "Cash: $" + str(round(GameManager.money))
	income_label.text = "Income: $" + str(round(GameManager.income_per_second)) + "/sec"
	reputation_label.text = "Reputation: " + str(round(GameManager.reputation))


func hire_artist():
	
	# TODO: Agregar randomizador de artistas predeterminados
	var artist = {
		"name": "Maya",
		"creativity": 60,
		"technique": 45,
		"charisma": 70,
		"stress": 20,
		"loyalty": 50
	}
	
	GameManager.artists.append(artist)
	current_artist = artist
	
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
	if not release_ready:
		$EventLog.text = "You don't have a finished song!"
		return
	
	GameManager.releases.append(current_release)
	GameManager.income_per_second += current_release.income_per_second

	release_ready = false
	$ReleasePanel/ReleaseButton.disabled = true
	$ReleasePanel/CreateSongButton.disabled = false

func create_song():
	if current_artist == null:
		$EventLog.text = "You need an artist before you can create a song!"
		return
	
	if release_ready:
		$EventLog.text = "You already have a song ready to release!"
	
	var inspiration = randf_range(0.0, 100)
	
	var quality = (
		current_artist.creativity * 0.4 +
		current_artist.technique * 0.3 +
		50.0 * 0.2 +
		inspiration * 0.1
	)
	
	var income = quality * current_artist.charisma * 0.001
	# TODO: Agregar randomizador de artistas predeterminados
	current_release = {
		"name": "First Light",
		"quality": quality,
		"artist": current_artist.name,
		"income_per_second": income
	}
	
	release_ready = true
	
	$ReleasePanel/SongName.text = current_release.name
	$ReleasePanel/QualityLabel.text = "Quality: " + str(round(quality)) + "%"
	$ReleasePanel/ReleaseButton.disabled = false
	$ReleasePanel/CreateSongButton.disabled = true
	
	$EventLog.text = "The song is ready for release"
	
