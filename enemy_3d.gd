extends CharacterBody3D

@onready var atk_area = $AttackArea
@onready var dmg_area = $DamageArea
@onready var nav_agent = $NavigationAgent3D
@onready var animator = $AuxScene/AnimationPlayer

var SPEED = 5.0
var ACCEL = 20
var ATTACK = 10
var KNOCKBACK = 16.0
var WALKSPEED = SPEED
var RUNSPEED = SPEED * 1.5

func _ready():
	nav_agent.target_position = global_position

func take_damage(_dmg):
	self.queue_free()

func _physics_process(delta: float) -> void:
	for player in get_tree().get_nodes_in_group("Player"):
		if $AttackRange.overlaps_body(player):
			nav_agent.target_position = player.global_position
			SPEED = RUNSPEED
		else:
			SPEED = WALKSPEED
		if nav_agent.distance_to_target() == 1:
			nav_agent.target_position = global_position
			
		if atk_area.overlaps_body(player):
			player.take_damage(ATTACK)
			player.inertia = (player.global_position-global_position)\
								.normalized() * KNOCKBACK
	var dir = (nav_agent.target_position-self.global_position)
	dir.y = 0
	if dir.length() > 0.01:
		var rot_angle = atan2(dir.x, dir.z)
		self.rotation.y = lerp_angle(rotation.y, rot_angle, 5 * delta)
	velocity = velocity.lerp(dir.normalized() * SPEED, ACCEL * delta)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if velocity.length() <= 1:
		nav_agent.target_position = self.global_position
		animator.play("Idle")
	elif SPEED == WALKSPEED:
		animator.play("UnarmedWalkForward")
	elif SPEED == RUNSPEED:
		animator.play("StandingRunForward")
	move_and_slide()
