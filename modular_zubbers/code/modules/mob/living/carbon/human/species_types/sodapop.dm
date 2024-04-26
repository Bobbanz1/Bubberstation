#define issodapop(A) (is_species(A, /datum/species/sodapop))


/datum/species/sodapop
	name = "\improper Sodapop"
	plural_form = "Sodapop"
	id = SPECIES_HUMAN
	inherent_traits = list(
		TRAIT_USES_SKINTONES,
	)
	mutant_bodyparts = list("wings" = "None")
	skinned_type = /obj/item/stack/sheet/animalhide/human
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT

/datum/species/sodapop/prepare_human_for_preview(mob/living/carbon/human/human)
	human.set_haircolor("#bb9966", update = FALSE) // brown
	human.set_hairstyle("Business Hair", update = TRUE)

/datum/species/sodapop/on_species_gain(mob/living/carbon/new_sodapop, datum/species/old_species, pref_load)
	. = ..()
	var/obj/item/clothing/neck/soda_tie/soda_pop = new_sodapop.get_item_by_slot(ITEM_SLOT_NECK)
	if(!istype(soda_pop, /obj/item/clothing/neck/soda_tie))
		if(new_sodapop.dropItemToGround(soda_pop))
			new_sodapop.equip_to_slot_or_del(new /obj/item/clothing/neck/soda_tie(new_sodapop), ITEM_SLOT_NECK)
	// If it wrks as I believe it would then this species will not be able to use their hands unless they've got the specific thing around their neck!
	ADD_TRAIT(new_sodapop, TRAIT_HANDS_BLOCKED, SPECIES_TRAIT)

/datum/species/sodapop/on_species_loss(mob/living/carbon/new_sodapop, datum/species/old_species, pref_load)
	. = ..()
	REMOVE_TRAIT(new_sodapop, TRAIT_HANDS_BLOCKED, SPECIES_TRAIT)


/obj/item/clothing/neck/soda_tie
	name = "soda tie"
	desc = "TEMPORARY."
	icon = 'icons/obj/clothing/neck.dmi'
	icon_state = "bowtie_greyscale"
	inhand_icon_state = "" //no inhands
	w_class = WEIGHT_CLASS_SMALL
	greyscale_config = /datum/greyscale_config/ties
	greyscale_config_worn = /datum/greyscale_config/ties/worn
	greyscale_colors = "#151516ff"
	flags_1 = IS_PLAYER_COLORABLE_1
	/// Contains a reference to who is wearing this thing...Hopefully
	var/mob/living/carbon/human/soda_pop

/obj/item/clothing/neck/soda_tie/Destroy()
	if(soda_pop != null)
		REMOVE_TRAIT(soda_pop, TRAIT_HANDS_BLOCKED, SPECIES_TRAIT)
	return ..()

/obj/item/clothing/neck/soda_tie/equipped(mob/living/user, slot)
	. = ..()
	// If we are not of this species then this item does absolutely nothing
	if(!issodapop(user))
		return
	if(slot & ITEM_SLOT_NECK)
		soda_pop = user
		REMOVE_TRAIT(soda_pop, TRAIT_HANDS_BLOCKED, SPECIES_TRAIT)

/obj/item/clothing/neck/soda_tie/dropped(mob/living/user)
	. = ..()
	if(!issodapop(user))
		return
	if(soda_pop.get_item_by_slot(ITEM_SLOT_NECK) == src)
		ADD_TRAIT(soda_pop, TRAIT_HANDS_BLOCKED, SPECIES_TRAIT)

