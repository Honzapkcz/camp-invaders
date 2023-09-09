extends Node



func play(sound: String):
	for audioPlayer in get_children():
		if audioPlayer.playing:
			continue
		audioPlayer.stream = load("res://Sounds/" + sound + ".mp3")
		audioPlayer.play()
