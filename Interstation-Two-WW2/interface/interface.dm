//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/website()
	set name = "website"
	set desc = "Visit the website"
	set hidden = 1
	if( config.websiteurl )
		if(alert("This will open the website in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.websiteurl)
	else
		src << "<span class='warning'>The website URL is not set in the server configuration.</span>"
	return

/client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki"
	set hidden = 1
	if( config.wikiurl )
		if(alert("This will open the wiki in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.wikiurl)
	else
		src << "<span class='warning'>The wiki URL is not set in the server configuration.</span>"
	return

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum"
	set hidden = 1
	if( config.forumurl )
		if(alert("This will open the forum in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.forumurl)
	else
		src << "<span class='warning'>The forum URL is not set in the server configuration.</span>"
	return

/client/verb/donate()
	set name = "donate"
	set desc = "Support the server via paypal."
	set hidden = 1
	if( config.donationurl )
		if(alert("This will open Paypal in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.donationurl)
	else
		src << "<span class='warning'>The donation URL is not set in the server configuration.</span>"
	return

/client/verb/github()
	set name = "Github"
	set desc = "Visit the Github"
	set hidden = 1
	if( config.githuburl )
		if(alert("This will open the Github in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.githuburl)
	else
		src << "<span class='warning'>The Github URL is not set in the server configuration.</span>"
	return

/client/verb/discord()
	set name = "discord"
	set desc = "Visit the discord"
	set hidden = 1
	if( config.discordurl )
		if(alert("This will open the Discord in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.discordurl)
	else
		src << "<span class='warning'>The Discord URL is not set in the server configuration.</span>"
	return

/client/verb/reportabug()
	set desc = "Report a bug, and a coder will eventually put in on Github."
	set hidden = 1

	establish_db_connection()

	rename

	var/bugname = input("What is a name for this bug?") as text
	if (lentext(bugname) > 50)
		bugname = copytext(bugname, 1, 51)
		src << "<span class = 'warning'>Your bug's name was clamped to 50 characters.</span>"

	if (!bugname)
		src << "<span class = 'warning'>Please put something in the name field.</span>"
		goto rename

	var/check_name_already_exists = database.execute("SELECT * FROM bug_reports WHERE name = '[bugname]';")
	if (islist(check_name_already_exists) && !isemptylist(check_name_already_exists))
		src << "<span class = 'danger'>This bug already exists! Please choose another name.</span>"
		goto rename

	bugname = sanitizeSQL(bugname)

	redesc

	var/bugdesc = input("What is the bug's description?") as text
	if (lentext(bugdesc) > 500)
		bugdesc = copytext(bugdesc, 1, 501)
		src << "<span class = 'warning'>Your bug's desc was clamped to 500 characters.</span>"

	if (!bugdesc)
		src << "<span class = 'warning'>Please put something in the description field.</span>"
		goto redesc

	bugdesc = sanitizeSQL(bugdesc)

	var/list/steps = list()
	var/bugrep = input("Does the bug have any special steps in order to recreate it?") in list("Yes", "No")
	if (bugrep == "Yes")
		var/stepnum = steps.len+1
		while ((input("Add another step? (#[stepnum])") in list ("Yes", "No")) == "Yes")
			var/step = input("What is a description of step number #[stepnum]?") as text
			step = sanitizeSQL(step)
			if (lentext(step) > 200)
				step = copytext(step, 1, 201)
				src << "<span class = 'warning'>[step] #[stepnum] was clamped to 200 characters.</span>"
			steps += step
			if (stepnum == 10)
				src << "<span class = 'warning'>Max number of steps (#[stepnum]) reached.</span>"
				break
			else
				stepnum = steps.len+1

	var/steps2string = ""
	for (var/_step in steps)
		steps2string += _step
		if (_step != steps[steps.len])
			steps2string += "&"

	reelse

	var/anything_else = input("Anything else?") as text
	if (lentext(anything_else) > 1000)
		bugdesc = copytext(anything_else, 1, 1001)
		src << "<span class = 'warning'>Your bug's 'anything else' value was clamped to 1000 characters.</span>"

	if (!anything_else)
		src << "<span class = 'warning'>Please put something in the anything else field.</span>"
		goto reelse

	anything_else = sanitizeSQL(anything_else)

	anything_else += "<br><i>Reported by [src], who was, at the time, [key_name(src)]</i>"

	if (bugname && bugdesc && bugrep && anything_else)
		establish_db_connection()
		if (database)
			if (database.execute("INSERT INTO bug_reports (name, desc, steps, other) VALUES ('[bugname]', '[bugdesc]', '[steps2string]', '[anything_else]');"))
				src << "<span class = 'notice'>Your bug was successfully reported. Thank you!</span>"
				message_admins("New bug report received from [key_name(src)].")
			else
				src << "<span class = 'warning'>A database error occured; your bug was NOT reported.</span>"
		else
			src << "<span class = 'warning'>A database error occured; your bug was NOT reported.</span>"
	else
		src << "<span class = 'warning'>Please fill in all fields!</span>"

#define RULES_FILE "config/rules.html"
/client/verb/rules()
	set name = "Rules"
	set desc = "Show Server Rules"
	set hidden = 1
	if( config.rulesurl )
		if(alert("This will open the rules in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.rulesurl)
	else
		src << "<span class='warning'>The rules URL is not set in the server configuration.</span>"
	return
//	src << browse(/*file(RULES_FILE)*/"https://discord.gg/3zjPhfb", "window=rules;size=480x320")
#undef RULES_FILE

/client/verb/hotkeys_help()
	set name = "hotkeys-help"
	set category = "OOC"

	var/admin = {"<font color='purple'>
Admin:
\tF5 = Aghost (admin-ghost)
\tF6 = player-panel-new
\tF7 = admin-pm
\tF8 = Invisimin
</font>"}

	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = drop
\te = equip
\tr = throw
\tt = say
\t5 = emote
\tx = swap-hand
\tspace = Use-iron-sights
\t, = rest
\tz = activate held object (or y)
\tj = toggle-aiming-mode
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = help-intent
\t2 = disarm-intent
\t3 = grab-intent
\t4 = harm-intent
\tPgUp = go up
\tPgDwn = go down
\tCtrl = drag
\tShift = examine
\tCtrl+S = scream
\tSpace = fire while in a tank
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+x = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = pull
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP = swap-hand
\tPGDN = activate held object
\tEND = throw
\tCtrl+S = scream
\tSpace = fire while in a tank
</font>"}

	var/robot_hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = unequip active module
\tt = say
\tspace = Use-iron-sights
\t, = rest
\tx = cycle active modules
\tz = activate held object (or y)
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = activate module 1
\t2 = activate module 2
\t3 = activate module 3
\t4 = toggle intents
\t5 = emote
\tCtrl = drag
\tShift = examine
</font>"}

	var/robot_other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = unequip active module
\tCtrl+x = cycle active modules
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = activate module 1
\tCtrl+2 = activate module 2
\tCtrl+3 = activate module 3
\tCtrl+4 = toggle intents
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = pull
\tINS = toggle intents
\tPGUP = cycle active modules
\tPGDN = activate held object
</font>"}

	if(isrobot(src.mob))
		src << robot_hotkey_mode
		src << robot_other
	else
		src << hotkey_mode
		src << other
	if(holder)
		src << admin
