extends Node2D

@onready var rain_particles = $"RainParticles"
@onready var starry_particles = $"StarryParticles"
@onready var sunbeam_particles = $"SunbeamParticles"
@onready var cloud_particles = $"CloudParticles"

var current_effect: CPUParticles2D = null

func change_effect(chapter_id: String):
	var target_effect: CPUParticles2D = null
	
	match chapter_id:
		"prologue":
			target_effect = rain_particles
		"chapter_1":
			target_effect = starry_particles
		"chapter_3":
			target_effect = sunbeam_particles
		"chapter_4", "chapter_7":
			target_effect = cloud_particles
			
	if current_effect == target_effect:
		return
		
	# Smooth transition: Stop emitting old particles, let them die naturally
	if current_effect:
		current_effect.emitting = false
		
	# Start emitting new particles
	current_effect = target_effect
	if current_effect:
		current_effect.emitting = true
		print("Playing live background effect: ", current_effect.name)
