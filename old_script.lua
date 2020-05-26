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

--# assume force_peace: method(declarer: string, declaree: string, apply_to_player: boolean)
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

local function battle_8_peaks()
	-- angrund, mors and skarsnik at war with no peace
	force_war("wh2_main_skv_clan_mors", "wh_main_grn_crooked_moon", true);
	force_war("wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor", true);
	force_no_peace("wh2_main_skv_clan_mors", "wh_main_grn_crooked_moon", false);
	force_no_peace("wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor", false);
	force_no_peace("wh_main_grn_crooked_moon", "wh_main_dwf_karak_izor", false);
end

local function pyramid_of_nagash()
	-- war between arkhan and sentinels with no peace
	force_war("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_the_sentinels", false);
	force_no_peace("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_the_sentinels", false);
	
	-- war between mannfred and sentinels with no peace
	force_war("wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_the_sentinels", false);
	force_no_peace("wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_the_sentinels", false);
	
	-- war between noctlus and sentinels with no peace
	force_war("wh2_dlc11_cst_noctilus", "wh2_dlc09_tmb_the_sentinels", false);
	force_no_peace("wh2_dlc11_cst_noctilus", "wh2_dlc09_tmb_the_sentinels", false);
	
	-- war between luthor and sentinels with no peace
	force_war("wh2_dlc11_cst_vampire_coast", "wh2_dlc09_tmb_the_sentinels", false);
	force_no_peace("wh2_dlc11_cst_vampire_coast", "wh2_dlc09_tmb_the_sentinels", false);
	
	-- settra and khatep cant control pyramid
	force_no_war("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_the_sentinels", false);
	force_no_war("wh2_dlc09_tmb_exiles_of_nehek", "wh2_dlc09_tmb_the_sentinels", false);
	
	-- unholly alliance can't attack each other
	force_no_war("wh2_dlc09_tmb_followers_of_nagash", "wh_main_vmp_vampire_counts", false);
	force_no_war("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc11_cst_noctilus", false);
	force_no_war("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc11_cst_vampire_coast", false);
	force_no_war("wh2_dlc09_tmb_followers_of_nagash", "wh_main_vmp_schwartzhafen", false);
	force_no_war("wh_main_vmp_vampire_counts", "wh2_dlc11_cst_noctilus", false);
	force_no_war("wh_main_vmp_vampire_counts", "wh2_dlc11_cst_vampire_coast", false);
	force_no_war("wh_main_vmp_vampire_counts", "wh_main_vmp_schwartzhafen", false);
	force_no_war("wh2_dlc11_cst_noctilus", "wh2_dlc11_cst_vampire_coast", false);
	force_no_war("wh2_dlc11_cst_noctilus", "wh_main_vmp_schwartzhafen", false);
	force_no_war("wh_main_vmp_schwartzhafen", "wh2_dlc11_cst_vampire_coast", false);
	
end

function apply_iconic_conflicts()
	battle_8_peaks();
	pyramid_of_nagash();
end;

local function change_badlands()
	-- give 8 peaks to skarsnik
	confed("wh_main_grn_crooked_moon", "wh_main_grn_necksnappers", false);
	
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
	
	-- peace between khemri and arkhan
	force_peace("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_followers_of_nagash", false);
	
	-- give zandri to khmeri
	cm:transfer_region_to_faction("wh2_main_land_of_the_dead_zandri", "wh2_dlc09_tmb_khemri");
	
	-- war between khemri and Necrarch and Numas
	force_war("wh2_dlc09_tmb_khemri", "wh2_main_vmp_necrarch_brotherhood", false);
	force_war("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_numas", false);	
	
	-- war between arkhan and rakaph
	force_war("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_rakaph_dynasty", false);
	
	-- give eye of the panther, vulture mountain to clan mordkin
	cm:transfer_region_to_faction("wh2_main_atalan_mountains_vulture_mountain", "wh2_main_vmp_necrarch_brotherhood");
	cm:transfer_region_to_faction("wh2_main_atalan_mountains_eye_of_the_panther", "wh2_main_vmp_necrarch_brotherhood");
	kill_faction_armies("wh2_main_dwf_greybeards_prospectors");
	
	-- confederate Hexoatl with tlaqa
	confed("wh2_main_lzd_hexoatl", "wh2_main_lzd_tlaqua", false);
	force_war("wh2_main_lzd_hexoatl", "wh2_main_skv_clan_mordkin", false);
	
	-- confederate exiles with dune kingdoms
	confed("wh2_dlc09_tmb_exiles_of_nehek", "wh2_dlc09_tmb_dune_kingdoms", false);
	
end

local function change_southlands()
	
	-- confederate Hexoatl with last defenders
	confed("wh2_main_lzd_hexoatl", "wh2_main_lzd_last_defenders", false);
	
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
	apply_iconic_conflicts();
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