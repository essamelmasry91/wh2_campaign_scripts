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

--# assume force_no_ai_peace: method(declarer: string, declaree: string)
local function force_no_ai_peace(declarer,declaree)
	if faction_is_human(declarer) == false and faction_is_human(declaree) == false then
		cm:force_diplomacy("faction:" .. declarer, "faction:" .. declaree, "peace", false, false, true);
	end
end

--# assume force_no_ai_war: method(declarer: string, declaree: string)
local function force_no_ai_war(declarer,declaree)
	if faction_is_human(declarer) == false and faction_is_human(declaree) == false then
		cm:force_diplomacy("faction:" .. declarer, "faction:" .. declaree, "war", false, false, true);
	end
end

--# assume declare_ai_war: method(declarer: string, declaree: string)
local function declare_ai_war(declarer,declaree)
	if faction_is_human(declarer) == false and faction_is_human(declaree) == false then
		cm:force_declare_war(declarer, declaree, true, true);
	end
end

--# assume force_ai_peace: method(declarer: string, declaree: string)
local function force_ai_peace(declarer,declaree)
	if faction_is_human(declarer) == false and faction_is_human(declaree) == false then
		cm:force_make_peace(declarer, declaree);
	end
end

--# assume confed: method(confederator: string, confederated: string, apply_to_player: boolean)
local function confed(confederator, confederated, apply_to_player)
	local confederate_faction = true;
	if apply_to_player == false then
		if faction_is_human(confederator) == true or faction_is_human(confederated) then
			confederate_faction = false;
		end
	end
	if confederate_faction == true then
		cm:force_confederation(confederator, confederated);
	end
end

local function make_undead_alliance()
	-- factions: noctilus, luthor, mannfred and arkhan
	-- arkhan and allies declare war with no peace on khemri
	-- arkhan and allies declare war with no peace on sentinels
end

local function change_badlands()
	-- give 8 peaks to skarsnik
	confed("wh_main_grn_crooked_moon", "wh_main_grn_necksnappers", false);
	
	-- -- war between skarsnik and red fangs
	-- declare_ai_war("wh_main_grn_crooked_moon", "wh_main_grn_red_fangs");
	
	-- -- angrund and mors in eternal war with skarsnik
	-- declare_ai_war("wh2_main_skv_clan_mors", "wh_main_grn_crooked_moon");
	-- force_no_ai_peace("wh2_main_skv_clan_mors", "wh_main_grn_crooked_moon");
	-- declare_ai_war("wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor");
	-- force_no_ai_peace("wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor");
	
	-- -- no starting war between Black crag and player dwarfs
	-- cm:force_make_peace("wh_main_dwf_dwarfs", "wh_main_grn_greenskins");
	-- cm:force_make_peace("wh_main_dwf_karak_izor", "wh_main_grn_greenskins");
	
	-- -- war between grimgor and karak azul
	-- cm:force_declare_war("wh_main_grn_greenskins", "wh_main_dwf_karak_azul", true, true);
	
	-- -- give crooked back mountain to clan rictus
	-- confed("wh2_dlc09_skv_clan_rictus", "wh2_dlc14_skv_rictus_clan_nest", false);
	
	-- -- no starting war between top knotz and khemri
	-- cm:force_make_peace("wh2_dlc09_tmb_khemri", "wh_main_grn_top_knotz");
	
	-- -- no starting war between bloody hands and dwarfs
	-- cm:force_make_peace("wh_main_dwf_dwarfs", "wh_main_grn_orcs_of_the_bloody_hand");
	
	-- -- no starting war between bloody hands and border princes
	-- cm:force_make_peace("wh_main_teb_border_princes", "wh_main_grn_orcs_of_the_bloody_hand");
	
	-- -- no starting war between scabby eye and dwarfs
	-- cm:force_make_peace("wh_main_dwf_dwarfs", "wh_main_grn_scabby_eye");
	
	-- -- no starting war between red fangs and dwarfs
	-- cm:force_make_peace("wh_main_dwf_dwarfs", "wh_main_grn_red_fangs");
	
	-- -- war between top knotz and teef snatchaz
	-- cm:force_declare_war("wh_main_grn_top_knotz", "wh_main_grn_teef_snatchaz", true, true);
	
	-- -- give kradtommen and misty mountains to clan gnaw and move character there
	-- cm:transfer_region_to_faction("wh_main_blightwater_misty_mountain", "wh2_main_skv_clan_gnaw");
	-- cm:transfer_region_to_faction("wh_main_blightwater_kradtommen", "wh2_main_skv_clan_gnaw");
	
	-- -- destroy karak azgal
	-- cm:set_region_abandoned("wh_main_blightwater_karak_azgal");
	
	-- -- give granite massif, deff gorge to mors to mors
	-- cm:transfer_region_to_faction("wh2_main_charnel_valley_granite_massif", "wh2_main_skv_clan_mors");
	-- cm:transfer_region_to_faction("wh_main_blightwater_deff_gorge", "wh2_main_skv_clan_mors");
	
	-- -- no starting war between mors and arachnos
	-- force_ai_peace("wh2_main_skv_clan_mors", "wh2_main_grn_arachnos");
	
	-- -- confed angrund with barak var
	-- confed("wh_main_dwf_karak_izor", "wh_main_dwf_barak_varr", false);
end

-- local function change_nehekhara()
	-- -- give eye of the panther, vulture mountain to clan mordkin
	-- cm:transfer_region_to_faction("wh2_main_atalan_mountains_vulture_mountain", "wh2_main_skv_clan_mordkin");
	-- cm:transfer_region_to_faction("wh2_main_atalan_mountains_eye_of_the_panther", "wh2_main_skv_clan_mordkin");	
	-- -- destroy greybeard prospectors
	-- kill_faction_armies("wh2_main_dwf_greybeards_prospectors");
	-- -- war between khemri and necrach, strigoi, numas
	-- cm:force_declare_war("wh2_dlc09_tmb_khemri", "wh2_main_vmp_strygos_empire", true, true);
	-- declare_ai_war("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_numas");
	-- declare_ai_war("wh2_dlc09_tmb_khemri", "wh2_main_vmp_necrarch_brotherhood");
	-- -- peace between rakaph and strigoi
	-- cm:force_make_peace("wh2_dlc09_tmb_rakaph_dynasty", "wh2_main_vmp_strygos_empire");
	-- -- war between arkhan and rakaph
	-- declare_ai_war("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_rakaph_dynasty");
	-- -- khemri and sentinels cant declare war
	-- force_no_ai_war("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_the_sentinels");
	-- -- peace between noctilus and bordelaux, carcassone and caledor
	-- force_ai_peace("wh2_dlc11_cst_noctilus","wh2_main_hef_caledor");
	-- cm:force_make_peace("wh2_dlc11_cst_noctilus", "wh_main_brt_bordeleaux");
	-- cm:force_make_peace("wh2_dlc11_cst_noctilus", "wh_main_brt_carcassonne");
	-- -- unholy alliance
	-- make_undead_alliance();
-- end

local function change_mortal_empires()
	change_badlands();
	-- change_nehekhara();
	-- Southlands
	-- Darklands
	-- World's Edge Mountains
	-- The empire
	-- Britonnia
	-- Southern Realms
	-- Norsca
	-- Ulthuan
	-- Lustria
	-- Naggaroth
end

function loreful_diplomacy_changes()
	if cm:is_new_game() then
		change_mortal_empires();
	end;
end