-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Loreful Diplomacy Changes
--	This script alters the Mortal Empires Campaign without tempering the startpos file
--	Changes were made with lore in mind
-- 	Changes include combining factions via confederations or moving AI factions to other positions
--	Created by Nayran
-- 
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

--# assume faction_is_human: method(faction: string)
local function faction_is_human(faction)
	return cm:get_faction(faction):is_human();
end

--# assume kill_faction_armies: method(faction_name: string)
function kill_faction_armies(faction_name)
	local faction_character_list = cm:get_faction(faction_name):character_list();	
	for i = 0, faction_character_list:num_items() - 1 do
		local cur_char = faction_character_list:item_at(i);			
		if cur_char:is_null_interface() == false then
			cm:kill_character(cur_char:command_queue_index(), true, true);
		end
	end;
end;

--# assume force_no_peace: method(declarer: string, declaree: string, apply_to_player: boolean)
local function apply_diplomacy(declarer, declaree, apply_to_player)
	local apply = true;
	if apply_to_player == true then
		if faction_is_human(declarer) == true or faction_is_human(declaree) == true then
			apply = false;
		end
	end
	return apply;
end;

--# assume force_no_peace: method(declarer: string, declaree: string, apply_to_player: boolean)
local function force_no_peace(declarer, declaree, apply_to_player)
	local force_no_peace = apply_diplomacy(declarer, declaree, apply_to_player);
	if force_no_peace == true then
		cm:force_diplomacy("faction:" .. declarer, "faction:" .. declaree, "peace", false, false, true);
	end
end

--# assume force_no_war: method(declarer: string, declaree: string, apply_to_player: boolean)
local function force_no_war(declarer, declaree, apply_to_player)
	local force_no_war = apply_diplomacy(declarer, declaree, apply_to_player);
	if force_no_war == true then
		cm:force_diplomacy("faction:" .. declarer, "faction:" .. declaree, "war", false, false, true);
	end
end

--# assume force_war: method(declarer: string, declaree: string, apply_to_player: boolean)
local function force_war(declarer, declaree, apply_to_player)
	local force_war = apply_diplomacy(declarer, declaree, apply_to_player);
	if force_war == true then
		cm:force_declare_war(declarer, declaree, true, true);
	end
end

--# assume force_ai_peace: method(declarer: string, declaree: string, apply_to_player: boolean)
local function force_peace(declarer, declaree, apply_to_player)
	local force_peace = apply_diplomacy(declarer, declaree, apply_to_player);
	if force_peace == true then
		cm:force_make_peace(declarer, declaree);
	end
end

--# assume confed: method(confederator: string, confederated: string, apply_to_player: boolean)
local function confed(confederator, confederated, apply_to_player)
	local confederate_factions = apply_diplomacy(declarer, declaree, apply_to_player);
	if confederate_factions then
		cm:force_confederation(confederator, confederated);
	end
end

local function change_badlands()
	-- give 8 peaks to skarsnik
	confed("wh_main_grn_crooked_moon", "wh_main_grn_necksnappers", false);
	
	-- angrund, mors and skarsnik at war with no peace
	force_war("wh2_main_skv_clan_mors", "wh_main_grn_crooked_moon", true);
	force_war("wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor", true);
	force_no_peace("wh2_main_skv_clan_mors", "wh_main_grn_crooked_moon", false);
	force_no_peace("wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor", false);
	force_no_peace("wh_main_grn_crooked_moon", "wh_main_dwf_karak_izor", false);
	
	-- war between top knotz and teef snatchaz
	force_war("wh_main_grn_top_knotz", "wh_main_grn_teef_snatchaz", false);
	
	-- give misty mountains to grom
	if faction_is_human("wh2_main_hef_yvresse") == false then
		confed("wh2_dlc15_grn_broken_axe", "wh2_dlc15_grn_skull_crag", false);
	end
	
end

local function change_nehekhara()
	-- peace between khemri and top knotz
	force_peace("wh2_dlc09_tmb_khemri", "wh_main_grn_top_knotz", false);
	
end

local function change_southlands()
	-- peace between border princes and bloody hands
	force_peace("wh_main_teb_border_princes", "wh_main_grn_orcs_of_the_bloody_hand", false);
end;

local function change_darklands()
	-- give crookback mountain to clan rictus
	confed("wh2_dlc09_skv_clan_rictus", "wh2_dlc14_skv_rictus_clan_nest", false);
end;

local function change_worlds_edge_mountains()
	-- peace between dwarfs and scabby eye
	force_peace("wh_main_dwf_dwarfs", "wh_main_grn_scabby_eye", false);
	
	-- peace between dwarfs and red fangs
	force_peace("wh_main_dwf_dwarfs", "wh_main_grn_red_fangs", true);
	
	-- peace between dwarfs and bloody hands
	force_peace("wh_main_dwf_dwarfs", "wh_main_grn_orcs_of_the_bloody_hand", true);
end;

local function change_the_empire()
end;

local function change_britonnia()
end;

local function change_southern_realms()
end;

local function change_norsca()
end;

local function change_ulthuan()
end;

local function change_lustria()
end;

local function change_naggaroth()
end;


local function change_mortal_empires()
	change_badlands();
	change_nehekhara();
	change_southlands();
	change_darklands();
	change_worlds_edge_mountains();
	change_the_empire();
	change_britonnia();
	change_southern_realms();
	change_norsca();
	change_ulthuan();
	change_lustria();
	change_naggaroth();
end

function loreful_diplomacy_changes()
	if cm:is_new_game() then
		change_mortal_empires();
	end;
end