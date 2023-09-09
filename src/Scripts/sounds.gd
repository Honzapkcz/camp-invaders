extends Node


func play(sound: String):
	var audioPlayers = get_children()
	for audioPlayer in audioPlayers:
		if audioPlayer.playing:
			continue
		audioPlayer.stream = load("res://Sounds/" + sound + ".mp3")
		audioPlayer.play()
		return
	print_debug("dropping")
