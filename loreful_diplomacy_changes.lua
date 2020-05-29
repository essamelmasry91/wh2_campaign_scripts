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
end;

local function transfer_region(region, faction, apply_to_player)
	local transfer = true;
	if apply_to_player == true then
		if faction_is_human(faction) == true then
			transfer = false;
		end
	end
	if transfer == true then
		cm:transfer_region_to_faction(region, faction);
	end
end;

local function change_badlands()

	-- war wuzzag and top knotz
	force_war("wh_main_grn_orcs_of_the_bloody_hand", "wh_main_grn_top_knotz", false);
	
	-- war between top knotz and teef snatchaz
	if faction_is_human("wh_main_grn_orcs_of_the_bloody_hand") == false then
		force_war("wh_main_grn_top_knotz", "wh_main_grn_teef_snatchaz", false);
	end
end

local function change_nehekhara()
	-- peace between khemri and top knotz
	force_peace("wh2_dlc09_tmb_khemri", "wh_main_grn_top_knotz", false);
	
	-- give zandri to khmeri // not lyoness
	if faction_is_human("wh2_dlc14_brt_chevaliers_de_lyonesse") == false then
		transfer_region("wh2_main_land_of_the_dead_zandri", "wh2_dlc09_tmb_khemri", false);
	end
	
	-- war between khemri and Necrarch and Numas and dune kingdoms
	force_war("wh2_dlc09_tmb_khemri", "wh2_main_vmp_necrarch_brotherhood", false);
	force_war("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_numas", false);
	force_war("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_dune_kingdoms", false);		
	
	-- war between arkhan and rakaph
	force_war("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_rakaph_dynasty", false);
	
	-- war between lyoness and arkhan
	force_war("wh2_dlc14_brt_chevaliers_de_lyonesse", "wh2_dlc09_tmb_followers_of_nagash", false);	
end

local function change_southlands()
	
end;

local function change_darklands()
	-- give crookback mountain to clan rictus
	confed("wh2_dlc09_skv_clan_rictus", "wh2_dlc14_skv_rictus_clan_nest", false);
	
	-- give nagashizzar to followers of nagash // not vmp, azhag, coast or noctilus
	if faction_is_human("wh_main_vmp_vampire_counts") == false and faction_is_human("wh2_dlc15_grn_bonerattlaz") == false and faction_is_human("wh2_dlc11_cst_vampire_coast") == false and faction_is_human("wh2_dlc11_cst_noctilus") == false then
		transfer_region("wh2_main_the_broken_teeth_desolation_of_nagash", "wh2_dlc09_tmb_followers_of_nagash", false);
		transfer_region("wh2_main_the_broken_teeth_nagashizar", "wh2_dlc09_tmb_followers_of_nagash", false);
	end
	
	-- war grimgor vs imrik and rictus
	force_war("wh_main_grn_greenskins", "wh2_dlc15_hef_imrik", false);
	force_war("wh_main_grn_greenskins", "wh2_dlc09_skv_clan_rictus", false);
end;

local function change_worlds_edge_mountains()
	-- peace between dwarfs and scabby eye
	force_peace("wh_main_dwf_dwarfs", "wh_main_grn_scabby_eye", false);
	
	-- peace between dwarfs and red fangs
	force_peace("wh_main_dwf_dwarfs", "wh_main_grn_red_fangs", true);
	
	-- peace between dwarfs and bloody hands
	force_peace("wh_main_dwf_dwarfs", "wh_main_grn_orcs_of_the_bloody_hand", true);
	
	-- war dwarfs and red eye
	force_war("wh_main_dwf_dwarfs", "wh_main_grn_red_eye", false);
	
end;

local function change_the_empire()
	-- peace between vlad and averland
	force_peace("wh_main_vmp_schwartzhafen", "wh_main_emp_averland", true);
	
	-- give vlad templehof and oberstyre //  not vc
	if faction_is_human("wh_main_vmp_vampire_counts") == false then
		transfer_region("wh_main_western_sylvania_castle_templehof", "wh_main_vmp_schwartzhafen", false);
		transfer_region("wh_main_western_sylvania_fort_oberstyre", "wh_main_vmp_schwartzhafen", false);
	end
	
	-- peace between vc and stirland
	force_peace("wh_main_vmp_vampire_counts", "wh_main_emp_stirland", true);
	
	-- norsca war with nordland
	force_war("wh_dlc08_nor_norsca", "wh_main_emp_nordland", false);
end;

local function change_britonnia()
	if faction_is_human("wh2_main_hef_yvresse") == false then
		transfer_region("wh_main_massif_orcal_massif_orcal", "wh2_dlc15_grn_broken_axe", false);
	end
	
	-- peace between brettonia and skullsmasherz
	force_peace("wh_main_brt_bretonnia", "wh_main_grn_skullsmasherz", false);
	
	-- peace between lyoness and cotheque
	force_peace("wh_main_brt_lyonesse", "wh2_main_hef_cothique", false);
	
	-- peace between baston and zeffin
	force_peace("wh_main_brt_bastonne", "wh_main_dwf_karak_ziflin", false);
end;

local function change_southern_realms()
	-- peace between border princes and bloody hands
	force_peace("wh_main_teb_border_princes", "wh_main_grn_orcs_of_the_bloody_hand", true);
end;

local function change_norsca()
	-- confed wulfrik with skaeling
	confed("wh_dlc08_nor_norsca", "wh_main_nor_skaeling", false);
	
	-- confed wintetooth with nagralflings
	confed("wh_dlc08_nor_wintertooth", "wh_dlc08_nor_naglfarlings", false);
	
	-- war wintertooth and kislev + kraka drak
	force_war("wh_dlc08_nor_wintertooth", "wh_main_ksl_kislev", false);
	force_war("wh_dlc08_nor_wintertooth", "wh_main_dwf_kraka_drak", false);	
end;

local function change_ulthuan()
	-- war between tyrion and scourge of khain
	force_war("wh2_main_hef_eataine", "wh2_main_def_scourge_of_khaine", false);
	
	-- war alith anar with scourge of khain
	force_war("wh2_main_hef_nagarythe", "wh2_main_def_scourge_of_khaine", false);
	
	-- confed loremaster with sappherie
	confed("wh2_main_hef_order_of_loremasters", "wh2_main_hef_saphery", false);
	
	-- peace between noct and caledor
	force_peace("wh2_dlc11_cst_noctilus", "wh2_main_hef_caledor", true);	
end;

local function change_lustria()
	-- war markus and nakai
	force_war("wh2_dlc13_lzd_spirits_of_the_jungle", "wh2_dlc13_emp_the_huntmarshals_expedition", false);
	
	-- war teclis and felheart
	force_war("wh2_dlc11_def_the_blessed_dread", "wh2_main_hef_order_of_loremasters", false);
end;

local function change_naggaroth()
	-- confed blessed dread with kar karond
	confed("wh2_dlc11_def_the_blessed_dread", "wh2_main_def_karond_kar", false);
	
	-- confed morathi with ghrond
	if faction_is_human("wh2_main_def_har_ganeth") == false then
		confed("wh2_main_def_cult_of_pleasure", "wh2_main_def_ghrond", false);
		-- give spite reach to har ganeth
		transfer_region("wh2_main_the_road_of_skulls_spite_reach", "wh2_main_def_har_ganeth", false);
	end
end;

local function battle_8_peaks()
	-- angrund, mors and skarsnik at war with no peace
	force_war("wh2_main_skv_clan_mors", "wh_main_grn_crooked_moon", true);
	force_war("wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor", true);
	force_no_peace("wh2_main_skv_clan_mors", "wh_main_grn_crooked_moon", false);
	force_no_peace("wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor", false);
	force_no_peace("wh_main_grn_crooked_moon", "wh_main_dwf_karak_izor", false);

	-- give 8 peaks to skarsnik
	confed("wh_main_grn_crooked_moon", "wh_main_grn_necksnappers", false);
	force_war("wh_main_grn_crooked_moon", "wh2_dlc15_skv_clan_volkn", false);
	
	-- peace skarsnik with norn
	force_peace("wh_main_grn_crooked_moon", "wh_main_dwf_karak_norn", true);
	
	-- war queek with aracnos
	force_war("wh2_main_skv_clan_mors", "wh2_main_grn_arachnos", false);
	
end

local function pyramid_of_nagash()
	-- war manny, noct and arkhan vs settra
	if faction_is_human("wh_main_vmp_vampire_counts") == false then
		force_war("wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_khemri", true);
	end
	if faction_is_human("wh2_dlc11_cst_noctilus") == false then
		force_war("wh2_dlc11_cst_noctilus", "wh2_dlc09_tmb_khemri", true);
	end	
	force_no_peace("wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_khemri", false);
	force_no_peace("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_khemri", false);
	force_no_peace("wh2_dlc11_cst_noctilus", "wh2_dlc09_tmb_khemri", false);
	
	-- war between arkhan and sentinels with no peace
	force_war("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_the_sentinels", false);
	force_no_peace("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_the_sentinels", false);
	
	-- war between mannfred and sentinels with no peace
	force_war("wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_the_sentinels", false);
	force_no_peace("wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_the_sentinels", false);
	
	-- war between noctlus and sentinels with no peace
	force_war("wh2_dlc11_cst_noctilus", "wh2_dlc09_tmb_the_sentinels", false);
	force_no_peace("wh2_dlc11_cst_noctilus", "wh2_dlc09_tmb_the_sentinels", false);
	
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

local function apply_iconic_conflicts()
	battle_8_peaks();
	
	pyramid_of_nagash();
	
	-- queen and the crone
	force_war("wh2_main_def_har_ganeth", "wh2_main_hef_avelorn", true);
	force_no_peace("wh2_main_def_har_ganeth", "wh2_main_hef_avelorn", false);
	
	-- eltharion war with grom
	force_no_peace("wh2_main_hef_yvresse", "wh2_dlc15_grn_broken_axe", false);
	
	-- tyrion and teclis war with malekith and morathi
	force_war("wh2_main_def_naggarond", "wh2_main_hef_eataine", true);
	force_no_peace("wh2_main_def_naggarond", "wh2_main_hef_eataine", false);
	force_war("wh2_main_def_cult_of_pleasure", "wh2_main_hef_eataine", true);
	force_no_peace("wh2_main_def_cult_of_pleasure", "wh2_main_hef_eataine", false);
	force_war("wh2_main_def_naggarond", "wh2_main_hef_order_of_loremasters", true);
	force_no_peace("wh2_main_def_naggarond", "wh2_main_hef_order_of_loremasters", false);
	force_war("wh2_main_def_cult_of_pleasure", "wh2_main_hef_order_of_loremasters", true);
	force_no_peace("wh2_main_def_cult_of_pleasure", "wh2_main_hef_order_of_loremasters", false);
	
	-- war pest with hexoatl, spirit jungle and tehenwin
	force_war("wh2_main_lzd_hexoatl", "wh2_main_skv_clan_pestilens", false);
	force_no_peace("wh2_main_lzd_hexoatl", "wh2_main_skv_clan_pestilens", false);
	force_war("wh2_dlc12_lzd_cult_of_sotek", "wh2_main_skv_clan_pestilens", false);
	force_no_peace("wh2_dlc12_lzd_cult_of_sotek", "wh2_main_skv_clan_pestilens", false);
	force_war("wh2_dlc13_lzd_spirits_of_the_jungle", "wh2_main_skv_clan_pestilens", false);
	force_no_peace("wh2_dlc13_lzd_spirits_of_the_jungle", "wh2_main_skv_clan_pestilens", false);
	force_war("wh2_main_lzd_itza", "wh2_main_skv_clan_pestilens", false);
	force_no_peace("wh2_main_lzd_itza", "wh2_main_skv_clan_pestilens", false);
	
	-- no peace between luthor and mutaneers
	force_no_peace("wh2_dlc11_cst_vampire_coast", "wh2_dlc11_cst_vampire_coast_rebels", false);
	
	-- malekith and morathi don't fight
	force_no_war("wh2_main_def_naggarond", "wh2_main_def_cult_of_pleasure", false);
	
	-- tyrion, eltharion, teclis and everqueen don't fight each other
	force_no_war("wh2_main_hef_eataine", "wh2_main_hef_avelorn", false);
	force_no_war("wh2_main_hef_eataine", "wh2_main_hef_yvresse", false);
	force_no_war("wh2_main_hef_eataine", "wh2_main_hef_order_of_loremasters", false);
	force_no_war("wh2_main_hef_avelorn", "wh2_main_hef_yvresse", false);
	force_no_war("wh2_main_hef_avelorn", "wh2_main_hef_order_of_loremasters", false);
	force_no_war("wh2_main_hef_order_of_loremasters", "wh2_main_hef_yvresse", false);
	
	-- karl, gelt and toddy dont fight
	force_no_war("wh_main_emp_empire", "wh_main_emp_middenland", false);
	force_no_war("wh_main_emp_empire", "wh2_dlc13_emp_golden_order", false);
	force_no_war("wh_main_emp_middenland", "wh2_dlc13_emp_golden_order", false);
	
	-- mazda, sotek , nakai, itza don't fight	
	force_no_war("wh2_main_lzd_hexoatl", "wh2_dlc12_lzd_cult_of_sotek", false);
	force_no_war("wh2_main_lzd_hexoatl", "wh2_dlc13_lzd_spirits_of_the_jungle", false);
	force_no_war("wh2_main_lzd_hexoatl", "wh2_main_lzd_itza", false);
	force_no_war("wh2_dlc12_lzd_cult_of_sotek", "wh2_dlc13_lzd_spirits_of_the_jungle", false);
	force_no_war("wh2_dlc12_lzd_cult_of_sotek", "wh2_main_lzd_itza", false);
	force_no_war("wh2_main_lzd_itza", "wh2_dlc13_lzd_spirits_of_the_jungle", false);
	
	-- grimgor, skarsnik and wuzzag can't fight each other
	force_no_war("wh_main_grn_greenskins", "wh_main_grn_crooked_moon", false);
	force_no_war("wh_main_grn_greenskins", "wh_main_grn_orcs_of_the_bloody_hand", false);
	force_no_war("wh_main_grn_crooked_moon", "wh_main_grn_orcs_of_the_bloody_hand", false);
	
	-- khemri, khalida and exiles dont fight
	force_no_war("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_lybaras", false);
	force_no_war("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_exiles_of_nehek", false);
	force_no_war("wh2_dlc09_tmb_lybaras", "wh2_dlc09_tmb_exiles_of_nehek", false);
	
	-- wintertooth and world walker dont fight
	force_no_war("wh_dlc08_nor_norsca", "wh_dlc08_nor_wintertooth", false);
	
end;

local function change_mortal_empires()
	core:remove_listener("character_completed_battle_greenskin_confederation_dilemma");
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
	apply_iconic_conflicts();
end

function loreful_diplomacy_changes()
	if cm:is_new_game() then
		change_mortal_empires();
	end;
end