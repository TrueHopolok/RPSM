extends Control


const SAVE_FILE_PATH = "user://savedata.idk"


var player_buttons : Array
var ai_images : Array
var ai_unknown : TextureRect
var ai = RPSM.new()
var status_label : Label
var score_label : Label
var gamestats_label : RichTextLabel
var gameover : Node
var player_score = 0
var ai_score = 0
var rounds_played = 0


func player_selected(origin):
	origin.disabled = true
	for node in player_buttons:
		if node == origin: continue
		node.disabled = false
		node.button_pressed = false


func player_lock():
	for node in player_buttons: 
		if node.button_pressed: continue
		node.visible = false
		node.disabled = true


func player_unlock():
	for node in player_buttons: 
		if node.button_pressed: continue
		node.disabled = false
		node.visible = true


func player_throw() -> int:
	for node in player_buttons:
		if !node.button_pressed: continue
		name = node.get_name()
		if   name == "ScissorsButton": return 0
		elif name == "RockButton":     return 1
		elif name == "PaperButton":    return 2
		else: return -1
	return -1


func ai_lock(ai_throw):
	ai_unknown.visible = false
	for node in ai_images:
		name = node.get_name()
		if (name == "AIpaper" && ai_throw == 2) \
		|| (name == "AIrock" && ai_throw == 1) \
		|| (name == "AIscissors" && ai_throw == 0):
			node.visible = true
			return


func ai_unlock():
	for node in ai_images: node.visible = false
	ai_unknown.visible = true


func game_start():
	gameover.visible = false
	ai.adapt(2)
	player_score = 0
	ai_score = 0
	rounds_played = 0
	score_label.text = "0:0"
	round_start()


func round_start():
	player_unlock()
	ai_unlock()
	for i in range(3, 0, -1):
		status_label.text = "Choose! Throw in " + str(i)
		await get_tree().create_timer(1.0).timeout
	round_finish()


func round_result(player_throw : int, ai_throw : int) -> int:
	if player_throw == ai_throw: return 0
	elif player_throw > ai_throw:
		if player_throw == 2 && ai_throw == 0: return -1
		return 1
	else:
		if player_throw == 0 && ai_throw == 2: return 1
		return -1


func round_finish():
	rounds_played += 1
	player_lock()
	var trw1 = player_throw()
	var trw2 = ai.throw()
	ai_lock(trw2)
	var round_result = round_result(trw1, trw2)
	ai.adapt(-round_result)
	var game_result = round_update_ui(round_result)
	if game_result == 0:
		await get_tree().create_timer(2.0).timeout
		round_start()
		return
	var main_str = ""
	if game_result == 1:
		main_str = "You won the game! Exiting in "
	else:
		main_str = "You lost the game! Exiting in "
	for i in range(3, 0, -1):
		status_label.text = main_str + str(i)
		await get_tree().create_timer(1.0).timeout
	gameover.visible = true
	stats_update(game_result, rounds_played, player_score, rounds_played - ai_score - player_score)
	gamestats_label.text = "\
Games played: %d\n\
Games won: %d\n\
Rounds played: %d\n\
Rounds won: %d\n\
Rounds tied: %d\n\
" % stats_get()


func round_update_ui(round_result : int) -> int:
	if round_result == 0:
		status_label.text = "Round tied!"
		return 0
	elif round_result == 1:
		player_score += 1
		score_label.text = str(player_score)+":"+str(ai_score)
		status_label.text = "Round won!"
		if player_score >= 3:
			return 1
	else:
		ai_score += 1
		score_label.text = str(player_score)+":"+str(ai_score)
		status_label.text = "Round lost!"
		if ai_score >= 3:
			return -1
	return 0


func stats_update(game_result : int, rounds_amount : int, rounds_won : int, rounds_tied : int):
	var data = stats_get()
	data[0] += 1
	if game_result == 1: data[1] += 1
	data[2] += rounds_amount
	data[3] += rounds_won
	data[4] += rounds_tied
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	for d in data: file.store_32(d)

func stats_get() -> Array:
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if file == null || file.get_error() == ERR_FILE_CANT_OPEN: return [0, 0, 0, 0, 0]
	var data = []
	for i in 5: data.append(file.get_32())
	return data


func _ready():
	player_buttons = [
		get_node("ScissorsButton"),
		get_node("PaperButton"),
		get_node("RockButton"),
	]
	for node in player_buttons:
		node.just_pressed.connect(player_selected)
	ai_unknown = get_node("AIunknown")
	ai_images = [
		get_node("AIscissors"),
		get_node("AIrock"),
		get_node("AIpaper"),
	]
	status_label = get_node("StatusLabel")
	score_label = get_node("ScoreLabel")
	gamestats_label = get_node("GameoverBG/GameStats")
	gamestats_label.text = "\
Games played: %d\n\
Games won: %d\n\
Rounds played: %d\n\
Rounds won: %d\n\
Rounds tied: %d\n\
" % stats_get()
	gameover = get_node("GameoverBG")
	get_node("GameoverBG/RestartButton").pressed.connect(game_start)
