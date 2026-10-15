ActionProfiles={}

SLASH_ActPro1 = "/ap"
SLASH_ActPro2 = "/actionprofiles"

SlashCmdList["ActPro"] = function(msg)
	args = {}
	for arg in msg:gmatch("%w+") do table.insert(args, arg) end

	if args[1] == "help" then
		print("TODO:")
		print("Commands: save restore list remove")
		
	elseif args[1] == "list" then
		print("")
		for profilename in pairs(ActionProfiles) do
			print(profilename)
		end
	elseif args[1] == "remove" then
		if args[2] == nil then
			print("Which profile did you want to remove?")
		end
		if ActionProfiles[args[2]] ~= nil then
			ActionProfiles[args[2]] = nil
			print("\"", args[2], "\" will be deleted")
		else
			print("questID (", args[2],") not found in autodecline list")
		end
	elseif args[1] == "save" then
		if args[2] == nil then
			print("a profile name must be provided to save.")
		end
		if ActionProfiles[args[2]] ~= nil then
			print("")
			print("profile already exists remove it to save again, or save as a different name")
			return
		end
		local abilityPositions={}
		for i = 1, 120 do
			abilitytype, abilityid, subtype = GetActionInfo(i)
			if abilitytype ~= nil then
				-- print(abilitytype, abilityid)
				if abilitytype == "macro"
				then
					abilityid = GetMacroInfo(abilityid)
				end
				ability = {
					["abilitytype"]=abilitytype,
					["abilityid"]=abilityid,
					["subtype"]=subtype
				}
				abilityPositions[i] = ability
			end
		end
		ActionProfiles[args[2]]=abilityPositions
		print("")
		print("saved ",args[2])

	elseif args[1] == "restore" then
		if args[2] == nil then
			print("a profile name must be provided to restore.")
		end	
		profile = ActionProfiles[args[2]]
		if profile == nil then
			print("profile doesn't seem to exist: ",args[2])
			return
		end
		ClearCursor()
		for i = 1, 120 do
			if profile[i] ~= nil then
				if profile[i].abilitytype == "spell" then
					C_Spell.PickupSpell(profile[i].abilityid)
				-- it is possible to have several macros with the same name if 
				-- this happens the first macro with that name is selected
				-- best practice don't have two macros with the same name
				elseif profile[i].abilitytype == "macro" then
					PickupMacro(profile[i].abilityid)
				elseif profile[i].abilitytype == "item" then
					C_Item.PickupItem(profile[i].abilityid)
				end
				PlaceAction(i)
				ClearCursor()
			else
				-- if there is no content for action bar slot then clear it
				PickupAction(i)
				ClearCursor()
				
			end
		end
	else
		print("use `/ap help` to see available commands")
	end

end