class_name Player
extends CharacterBody2D

const _ATTACK_RUN_COOLDOWN = 0.2

## Player properties
@export var _COLOR: Color
@export var _MOVEMENT_SPEED: int
@export var MAX_HEALTH: int
@export var _ATTACK_DMG: int
@export var CONTROLLED: bool

signal damage_taken(damage: int)

## Local variables
var _is_clickmoving: bool
var _is_attacking: bool
var _click_pos: Vector2
var _can_move: bool

func _ready() -> void:
	_is_clickmoving = true
	_is_attacking = false
	_can_move = true
	_click_pos = Vector2(position.x, position.y)
	$PlayerSprite.color = _COLOR

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		print(str(self) + " " + str(_is_attacking) + " " + str(_can_move))
	if CONTROLLED and not self._is_attacking and _can_move:
		_click_move() if _is_clickmoving else _wasd_move()
	move_and_slide()

func _wasd_move() -> void:
	var pre_input_velocity := velocity
	var dir := Input.get_vector("left", "right", "up", "down")
	velocity = dir.normalized() * _MOVEMENT_SPEED

func _click_move() -> void:
	if Input.is_action_just_pressed("click"):
		_click_pos = get_global_mouse_position()
		
	var target_location := (_click_pos - position).normalized()
	
	if position.distance_to(_click_pos) > 5:
		velocity = target_location * _MOVEMENT_SPEED
	else:
		velocity = Vector2.ZERO

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		for attacker in get_tree().get_nodes_in_group("players"):
			if attacker != self:
				attacker._is_attacking = true
				self.on_interaction(self, attacker)

func on_interaction(target: Player, attacker: Player) -> void:
	attacker._can_move = false
	attacker._is_attacking = false
	$CooldownTimer.start(_ATTACK_RUN_COOLDOWN)

func calculate_damage() -> int:
	return _ATTACK_DMG

func _on_move_cooldown_timeout() -> void:
	for attacker in get_tree().get_nodes_in_group("players"):
		if attacker != self:
			attacker._can_move = true
			self.damage_taken.emit(attacker.calculate_damage())
