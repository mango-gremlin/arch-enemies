# This file contains all the overworld dynamic dialogues

class_name OverworldDialogues

# save dialogue portraits
static var snake_portrait = "res://assets/art/characters/portraits/Portrait_Snake.png"
static var deer_portrait = "res://assets/art/characters/portraits/Portrait_Deer.png"
static var spider_portrait = "res://assets/art/characters/portraits/Portrait_Spooder.png"
static var squirrel_portrait = "res://assets/art/characters/portraits/Portrait_Squirrel.png"
static var squirrel_nutter_portrait = "res://assets/art/characters/portraits/Portrait_Squirrel_Ol_Nutter.png"
static var frog_portrait = "res://assets/art/characters/portraits/Portrait_Toadally_Anonymous.png"
static var fox_portrait = "res://assets/art/characters/portraits/Portrait_Fox.png"

# ID 1: Stefan
static func dialogue_snake_stefan():
	# FIXME remove initialization that will be overwritten anyway!
	var dynamic_dialogue = DynamicDialogue.new(spider_portrait, "no page here", "", snake_portrait, "", "")
	
	var unsolved_pages:Array[DynamicPage] = [
		DynamicPage.new("Hello zzere little foxzz, why are you bozzering mee?", "Ssssssstefan", snake_portrait),
		DynamicPage.new("Hi, we want your help for fixing the dam to prevent more floods!", "You", fox_portrait),
		DynamicPage.new("Szzoo you want my help, but what do I get from zzat? I can szzwim you know, szoo I don't really caree about zze water.", "Ssssssstefan", snake_portrait),
		DynamicPage.new("Hmm maybe you could let me borrow one of your taszzty little szzquirrel friendszz? Szz szz szz, juszzt kidding... unlesszz?", "Ssssssstefan", snake_portrait),
		DynamicPage.new("...", "You", fox_portrait),
		DynamicPage.new("Maybe I can find something else you could eat. Would you help us then?", "You", fox_portrait),
		DynamicPage.new("Ohh zzat would be very kind! Of courszze I would help you... aszz long as I have szzomething to szzwallow and digeszzt.", "Ssssssstefan", snake_portrait),

	]
	var solved_pages:Array[DynamicPage] = [
		DynamicPage.new("Is zzat an eegg?? Oh zzat's szzoo niczze of youu! I will help you, but don't get too closzze to me or I might take a bite. I can't help it, it'szz a reflexzz.", "Ssssssstefan",snake_portrait)
	]
	
	dynamic_dialogue.insert_pages(unsolved_pages,solved_pages)
	
	return dynamic_dialogue

# ID 2: Grandfather Longlegs
static func dialogue_spider_grandpa():
	# FIXME remove initialization that will be overwritten anyway!
	var dynamic_dialogue = DynamicDialogue.new(spider_portrait, "no page here", "",
	spider_portrait, "", "")
	
	var unsolved_pages:Array[DynamicPage] = [
		DynamicPage.new("Can you help solve the flooding issue?", "You", fox_portrait),
		DynamicPage.new("You young whipper-snapper, get off my net!", "Grandfather Longlegs", spider_portrait), 
		DynamicPage.new("The last round of rowdy blaggards already scattered my flies and I need to gather new ones to feed my 6582 grandchildren!", "", spider_portrait),
		DynamicPage.new("Once they are cared for I will consider helping you.", "Grandfather Longlegs", spider_portrait),
	]
	
	var solved_pages:Array[DynamicPage] = [
		DynamicPage.new("Many thanks, young lad. Now that my family is cared for I will aid you on your quest.", "Grandfather Longlegs",spider_portrait)
	]
	
	dynamic_dialogue.insert_pages(unsolved_pages,solved_pages)
	
	
	return dynamic_dialogue

# ID 3: Esther Egg Squirrel
static func dialogue_squirrel_egg():
	# FIXME remove initialization that will be overwritten anyway!
	var dynamic_dialogue = DynamicDialogue.new(squirrel_portrait, "no page here", "",
	squirrel_portrait, "", "")
	
	var unsolved_pages:Array[DynamicPage] = [
		DynamicPage.new("Behold!", "Esther", squirrel_portrait),
		DynamicPage.new("I have found something very special: a purple striped walnut of impressive size! A magnificent specimen.", "Esther", squirrel_portrait),
		DynamicPage.new("... Thats an egg.", "You", fox_portrait),
		DynamicPage.new("What! Impossible! I wanted a nut! Bring me one so I can check.", "Esther", squirrel_portrait),
	]
	
	var solved_pages:Array[DynamicPage] = [
		DynamicPage.new("This is way better than the purple one! Ill take this one and you get the purple one.", "Esther",squirrel_portrait)
	]
	
	dynamic_dialogue.insert_pages(unsolved_pages,solved_pages)
	
	
	return dynamic_dialogue

# ID 4: Ol'Nutter
static func dialogue_squirrel_ol_nutter():
	# FIXME remove initialization that will be overwritten anyway!
	var dynamic_dialogue = DynamicDialogue.new(squirrel_nutter_portrait, "no page here", "",
	squirrel_nutter_portrait, "", "")
	
	var unsolved_pages:Array[DynamicPage] = [
		DynamicPage.new("Did you see that nut-damned frog at the meeting back there?! I tell you, that creature is behind everything! ", "Ol' Nutter", squirrel_nutter_portrait),
		DynamicPage.new("Well it seems like it wanted everyone to argue, instead of helping me.", "You", fox_portrait),
		DynamicPage.new("HA! Just like I told them! But does anyone believe me? NO! ", "Ol' Nutter", squirrel_nutter_portrait),
		DynamicPage.new("I'm telling you, whatever it is that this toad is doing, the others are in on it! Only NUT remains at the side of truth!", "Ol' Nutter", squirrel_nutter_portrait),
		DynamicPage.new("NUT? I'm not sure I've heard of them.", "You", fox_portrait),
		DynamicPage.new("The New Union of Truth - or Nutters for short - of course. The only ones who are not sheep blindly following the croaking of frogs!", "Ol' Nutter", squirrel_nutter_portrait),
		DynamicPage.new("Except you of course. Do you want to join our.. elusive ranks?", "Ol' Nutter", squirrel_nutter_portrait),
		DynamicPage.new("I'm not sure if I have the... qualifications for your cult - organization I mean.", "You", fox_portrait),
		DynamicPage.new("But you can see how we need to band together, right? With the beavers being sick, this flooding will just get worse.", "You", fox_portrait),
		DynamicPage.new("Can you and your... Nutters help me out dealing with the problem?", "You", fox_portrait),
		DynamicPage.new("Hehe, I'd always help out someone interested in the truth! But the others may need some convincing...", "Ol' Nutter", squirrel_nutter_portrait),
		DynamicPage.new("Can you travel to the frog-invested island to the east, and bring some evidence to me? I'm sure the entirety of NUT will see your noble cause!", "Ol' Nutter", squirrel_nutter_portrait)
	]
	
	var solved_pages:Array[DynamicPage] = [
		DynamicPage.new("~Excited Squeaking~...this is incredible! Now everyone will believe in the NUT! We can rise up against Big Frog! We'll join your noble cause!", "Ol' Nutter",squirrel_nutter_portrait)
	]
	
	dynamic_dialogue.insert_pages(unsolved_pages,solved_pages)
	
	
	return dynamic_dialogue

# ID 5: Toadally Anonymous
static func dialogue_starting_conflict():
	# FIXME remove initialization that will be overwritten anyway!
	var dynamic_dialogue = DynamicDialogue.new(frog_portrait, "no page here", "",
	frog_portrait, "", "")
	
	var unsolved_pages:Array[DynamicPage] = [
		DynamicPage.new("~ You hear a loud discussion amongst different animals... ~", "You", fox_portrait),
		DynamicPage.new("~ You and your friends decide to investigate ~", "You", fox_portrait),
		DynamicPage.new("My precious webs are broken! The travesty! Watch your step, youngins!", "Grandfather Longlegs", spider_portrait),
		DynamicPage.new("... if only there was somebody here with really large hooves ...", "Toadally Anonymous", frog_portrait),
		DynamicPage.new("I'm telling you, it must be the frogs! They have trampled your nets and want your children to starve!", "Ol' Nutter", squirrel_nutter_portrait),
		DynamicPage.new("... thats hard to believe, frogs are way too small to reach your webs ...", "Toadally Anonymous", frog_portrait),
		DynamicPage.new("Someone do something about this flood!! Stop being so useless, you rabble!!! My glorious antlers must remain dry!", "Deerington von Antler", deer_portrait),
		DynamicPage.new("... I would be careful, I heard the spiders want to build their new webs between your antlers ...", "Toadally Anonymous", frog_portrait),
		DynamicPage.new("Behold!! My new nut will solve this issue!! - ... wait. What's that noise?", "Esther", squirrel_portrait),
		DynamicPage.new("~ a snake comes out of the bushes ~ ... I'm sssszzzo hungryyy, I need zzzsomezzing I can sssszink my teezz into...", "Ssssssstefan", snake_portrait),
		DynamicPage.new("... Save yourselves! The snake will devour us all! It's devious and evil ...", "Toadally Anonymous", frog_portrait),
		DynamicPage.new("~ The squirrels flee in terror, and the discussion dies down. The other animals disperse...~", "You", fox_portrait),
		DynamicPage.new("... hehehehehehehehehehehehehehe ...", "Toadally Anonymous", frog_portrait),
		#DynamicPage.new("<<< due to a series of unfortunate events, the fox must interact with the toadally anonymous individual again after finishing this dialogue. Thank you! >>>", frog_portrait),
	]
	var solved_pages:Array[DynamicPage] = [
		DynamicPage.new("... seems like no one wants to help you, hehehehehehehe ... they're playing right into my webbed hands ...", "Toadally Anonymous",frog_portrait)
	]
	
	dynamic_dialogue.insert_pages(unsolved_pages,solved_pages)
	
	
	return dynamic_dialogue

# ID 6: Final Thank you
static func dialogue_final():
	var dynamic_dialogue = DynamicDialogue.new(squirrel_portrait, "no page here", "", frog_portrait, "", "")
	
	var unsolved_pages:Array[DynamicPage] = [
		DynamicPage.new("If you ran into any problems while playing, please do not hesitate to tell us.", "Toadally Anonymous", frog_portrait),
		DynamicPage.new("We also would like to know what you thought of the game in general:", "Toadally Anonymous", frog_portrait),
		DynamicPage.new("- understandability - difficulty (esp: how many animals did you use? Did you have too many?) - fun/boring - suggestions -", "Toadally Anonymous", frog_portrait),
		DynamicPage.new("Thanks for playing our game! We really appreciate it!", "Toadally Anonymous", frog_portrait),
	]
	
	var solved_pages:Array[DynamicPage] = [
		DynamicPage.new("Thanks for playing!", "Toadally Anonymous",frog_portrait)
	]
	
	dynamic_dialogue.insert_pages(unsolved_pages,solved_pages)
	
	return dynamic_dialogue
