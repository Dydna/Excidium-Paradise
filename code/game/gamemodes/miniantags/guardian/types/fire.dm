/mob/living/simple_animal/hostile/guardian/fire
	a_intent = INTENT_HELP
	melee_damage_lower = 10
	melee_damage_upper = 10
	attack_sound = 'sound/items/Welder.ogg'
	attacktext = "sears"
	damage_transfer = 0.8
	range = 10
	playstyle_string = "As a <b>Chaos</b> type, you have only light damage resistance, but will ignite any enemy you bump into. In addition, your melee attacks will randomly teleport enemies."
	environment_smash = 1
	magic_fluff_string = "..And draw the Wizard, bringer of endless chaos!"
	tech_fluff_string = "Boot sequence complete. Crowd control modules activated. Holoparasite swarm online."
	bio_fluff_string = "Your scarab swarm finishes mutating and stirs to life, ready to sow havoc at random."
	var/toggle = FALSE

/mob/living/simple_animal/hostile/guardian/fire/Life() //Dies if the summoner dies
	..()
	if(summoner)
		summoner.ExtinguishMob()
		summoner.adjust_fire_stacks(-20)

/mob/living/simple_animal/hostile/guardian/fire/ToggleMode()
	if(src.loc == summoner)
		if(toggle)
			to_chat(src, "You switch to dispersion mode, and will teleport victims away from your master.")
			toggle = FALSE
		else
			to_chat(src, "You  switch to deception mode, and will turn your victims against their allies.")
			toggle = TRUE

/mob/living/simple_animal/hostile/guardian/fire/AttackingTarget()
	if(..())
		if(toggle)
			if(ishuman(target) && !summoner)
				spawn(0)
					new /obj/effect/hallucination/delusion(target.loc, target, force_kind="custom", duration=200, skip_nearby=0, custom_icon = src.icon_state, custom_icon_file = src.icon)
		else
			if(prob(45))
				if(istype(target, /atom/movable))
					var/atom/movable/M = target
					if(!M.anchored && M != summoner)
						new /obj/effect/overlay/temp/guardian/phase/out(get_turf(M))
						do_teleport(M, M, 10)
						new /obj/effect/overlay/temp/guardian/phase/out(get_turf(M))

/mob/living/simple_animal/hostile/guardian/fire/Crossed(AM as mob|obj)
	..()
	collision_ignite(AM)

/mob/living/simple_animal/hostile/guardian/fire/Bumped(AM as mob|obj)
	..()
	collision_ignite(AM)

/mob/living/simple_animal/hostile/guardian/fire/Bump(AM as mob|obj)
	..()
	collision_ignite(AM)

/mob/living/simple_animal/hostile/guardian/fire/proc/collision_ignite(AM as mob|obj)
	if(istype(AM, /mob/living/))
		var/mob/living/M = AM
		if(AM != summoner && M.fire_stacks < 7)
			M.fire_stacks = 7
			M.IgniteMob()

/mob/living/simple_animal/hostile/guardian/fire/Bump(AM as mob|obj)
	..()
	collision_ignite(AM)
