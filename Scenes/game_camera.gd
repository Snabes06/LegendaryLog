extends Camera2D

var players: Array[Node]
var follow: Player

func _ready() -> void:
	players = get_tree().get_nodes_in_group("players")
	for player in players:
		if player.CONTROLLED:
			follow = player

func _physics_process(delta: float) -> void:
	follow_player()
	if Input.is_action_just_pressed("switch_player_view"):
		_switch_player_view()

func follow_player() -> void:
	position = follow.position

func _switch_player_view() -> void:
	for player in players:
		if player.CONTROLLED and player == players.back():
			player.CONTROLLED = false
			follow = players[0]
			follow.CONTROLLED = true
			print("2")
			return
		if player.CONTROLLED:
			player.CONTROLLED = false
			follow = players[players.find(player) + 1]
			follow.CONTROLLED = true
			print("1")
			return
