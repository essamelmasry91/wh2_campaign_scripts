-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	Nayran WH2 Campaign Script
--	This script alters the Mortal Empires Campaign without tempering the startpos file
--	Changes were made with lore in mind
-- 	Changes include combining factions via confederations or moving AI factions to other positions
--	Created by Nayran
-- 
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

--# assume disable_event_log: method(disable: boolean)
local function disable_event_log(disable)
	cm:disable_event_feed_events(disable, "", "", "faction_joins_confederation")
	cm:disable_event_feed_events(disable, "", "", "diplomacy_faction_encountered")
	cm:disable_event_feed_events(disable, "", "", "diplomacy_trespassing")
	cm:disable_event_feed_events(disable, "", "", "conquest_province_secured")
	cm:disable_event_feed_events(disable, "", "", "conquest_province_contested")
	cm:disable_event_feed_events(disable, "", "", "faction_resource_lost")
	cm:disable_event_feed_events(disable, "", "", "conquest_sea_region_controlled")
	cm:disable_event_feed_events(disable, "", "", "conquest_sea_region_contested")
	cm:disable_event_feed_events(disable, "", "wh_event_subcategory_character_deaths", "")
end

--# assume heal_garrison: method(region: string)
local function heal_garrison(region)
	local region = cm:get_region(region);
    cm:heal_garrison(region:cqi());
end

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

--# assume apply_diplomacy: method(declarer: string, declaree: string, apply_to_player: boolean)
local function apply_diplomacy(declarer, declaree, apply_to_player)
	local apply = true;
	if apply_to_player == false then
		if faction_is_human(declarer) == true or faction_is_human(declaree) == true then
			apply = false;
		end
	end
	return apply;
end;

--# assume force_millitary_alliance: method(proposingFaction: string, targetFaction: string, apply_to_player: boolean)
local function force_millitary_alliance(proposingFaction, targetFaction, apply_to_player)
	local force_millitary_alliance = apply_diplomacy(proposingFaction, targetFaction, apply_to_player);
	if force_millitary_alliance == true then
		cm:force_alliance(proposingFaction, targetFaction, true);
	end
end

--# assume force_defensive_alliance: method(proposingFaction: string, targetFaction: string, apply_to_player: boolean)
local function force_defensive_alliance(proposingFaction, targetFaction, apply_to_player)
	local force_defensive_alliance = apply_diplomacy(proposingFaction, targetFaction, apply_to_player);
	if force_defensive_alliance == true then
		cm:force_alliance(proposingFaction, targetFaction, false);
	end
end

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

--# assume make_trade_agreement: method(proposingFaction: string, targetFaction: string, apply_to_player: boolean)
local function make_trade_agreement(proposingFaction, targetFaction, apply_to_player)
	local make_trade_agreement = apply_diplomacy(proposingFaction, targetFaction, apply_to_player);
	if make_trade_agreement then
		cm:force_make_trade_agreement(proposingFaction, targetFaction);
	end
end

--# assume set_settlement_level: method(region: string, level: integer, apply_to_player: boolean)
local function set_settlement_level(region, level, apply_to_player)
    local settlement = cm:get_region(region):settlement();
    cm:instantly_set_settlement_primary_slot_level(settlement, level);
end

--# assume transfer_region: method(region: string, faction: string, level: integer, apply_to_player: boolean)
local function transfer_region(region, faction, level, apply_to_player)
	local transfer = true;
	if apply_to_player == true then
		if faction_is_human(faction) == true then
			transfer = false;
		end
	end
	if transfer == true then
		cm:transfer_region_to_faction(region, faction);
		if level > 0 then
			set_settlement_level(region, level, apply_to_player);
		end
		heal_garrison(region);
	end
end;

--# assume abandon_region: method(region: string, initial_faction: string, apply_to_player: boolean)
local function abandon_region(region, initial_faction, apply_to_player)
	local abandon = true;
	if apply_to_player == true then
		if faction_is_human(initial_faction) == true then
			abandon = false;
		end
	end
	if abandon == true then
		cm:set_region_abandoned(region);
	end
end 

local function setup_undead_alliance()
	
	local player_is_arkhan = faction_is_human("wh2_dlc09_tmb_followers_of_nagash");
	local player_is_mannfred = faction_is_human("wh_main_vmp_vampire_counts");
	local player_is_vlad = faction_is_human("wh_main_vmp_schwartzhafen");
	local player_is_luthor = faction_is_human("wh2_dlc11_cst_vampire_coast");
	local player_is_dreadfleet = faction_is_human("wh2_dlc11_cst_noctilus");
	
	if not player_is_arkhan and not player_is_mannfred and not player_is_vlad and not player_is_luthor and not player_is_dreadfleet then
		-- war on sentinels
		force_war("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_the_sentinels", false);
		force_war("wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_the_sentinels", false);
		force_war("wh2_dlc11_cst_noctilus", "wh2_dlc09_tmb_the_sentinels", false);
		force_war("wh2_dlc16_vmp_lahmian_sisterhood", "wh2_dlc09_tmb_the_sentinels", false);
		force_no_peace("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_the_sentinels", false);
		force_no_peace("wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_the_sentinels", false);
		force_no_peace("wh2_dlc11_cst_noctilus", "wh2_dlc09_tmb_the_sentinels", false);
		force_no_peace("wh2_dlc16_vmp_lahmian_sisterhood", "wh2_dlc09_tmb_the_sentinels", false);
		
		-- war on khmeri
		force_war("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_khemri", false);
		force_war("wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_khemri", false);
		force_war("wh2_dlc11_cst_noctilus", "wh2_dlc09_tmb_khemri", false);
		force_war("wh2_dlc16_vmp_lahmian_sisterhood", "wh2_dlc09_tmb_khemri", false);
		force_no_peace("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_khemri", false);
		force_no_peace("wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_khemri", false);
		force_no_peace("wh2_dlc11_cst_noctilus", "wh2_dlc09_tmb_khemri", false);
		force_no_peace("wh2_dlc16_vmp_lahmian_sisterhood", "wh2_dlc09_tmb_khemri", false);
		
		-- war on lybaras
		force_war("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_lybaras", false);
		force_war("wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_lybaras", false);
		force_war("wh2_dlc11_cst_noctilus", "wh2_dlc09_tmb_lybaras", false);
		force_war("wh2_dlc16_vmp_lahmian_sisterhood", "wh2_dlc09_tmb_lybaras", false);
		force_no_peace("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc09_tmb_lybaras", false);
		force_no_peace("wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_lybaras", false);
		force_no_peace("wh2_dlc11_cst_noctilus", "wh2_dlc09_tmb_lybaras", false);
		force_no_peace("wh2_dlc16_vmp_lahmian_sisterhood", "wh2_dlc09_tmb_lybaras", false);
		
		-- military alliance between dreadfleet arkhan mannfred and lahmia sisterhood
		force_millitary_alliance("wh2_dlc09_tmb_followers_of_nagash", "wh_main_vmp_vampire_counts", false);
		force_millitary_alliance("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc11_cst_noctilus", false);
		force_millitary_alliance("wh2_dlc09_tmb_followers_of_nagash", "wh2_dlc16_vmp_lahmian_sisterhood", false);
		
		force_millitary_alliance("wh_main_vmp_vampire_counts", "wh2_dlc11_cst_noctilus", false);
		force_millitary_alliance("wh_main_vmp_vampire_counts", "wh2_dlc16_vmp_lahmian_sisterhood", false);
		
		force_millitary_alliance("wh2_dlc11_cst_noctilus", "wh2_dlc16_vmp_lahmian_sisterhood", false);
		
		-- defensive alliance between vlad and mannfred
		force_defensive_alliance("wh_main_vmp_vampire_counts", "wh_main_vmp_schwartzhafen", false);
	end
end

local function setup_8_peaks()
	-- angrund, mors and crooked moon at war
	force_war("wh2_main_skv_clan_mors", "wh_main_grn_crooked_moon", true);
	force_war("wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor", true);
	force_no_peace("wh_main_dwf_karak_izor", "wh_main_grn_crooked_moon", false);
	force_no_peace("wh_main_dwf_karak_izor", "wh2_main_skv_clan_mors", false);

	-- give 8 peaks to skarsnik
	confed("wh_main_grn_crooked_moon", "wh_main_grn_necksnappers", false);	
end

local function setup_lustria()
	
	local player_is_teclis = faction_is_human("wh2_main_hef_order_of_loremasters");
	local player_is_skrolk = faction_is_human("wh2_main_skv_clan_pestilens");
	local player_is_felheart = faction_is_human("wh2_dlc11_def_the_blessed_dread");
	local player_is_luthor = faction_is_human("wh2_dlc11_cst_vampire_coast");
	local player_is_gorrok = faction_is_human("wh2_main_lzd_itza");
	local player_is_tenehuine = faction_is_human("wh2_dlc12_lzd_cult_of_sotek");
	
	if not player_is_skrolk and not player_is_teclis and not player_is_gorrok and not player_is_felheart and not player_is_luthor and not player_is_tenehuine then
		-- war felheart and teclis
		force_war("wh2_dlc11_def_the_blessed_dread", "wh2_main_hef_order_of_loremasters", false);
		
		-- give pox march to vampire coast
		transfer_region("wh2_main_vampire_coast_pox_marsh", "wh2_dlc11_cst_vampire_coast", 0, false);
		
		-- give blood swamps to vampire coast
		transfer_region("wh2_main_vampire_coast_the_blood_swamps", "wh2_dlc11_cst_vampire_coast", 2, false);
		
		-- give mangrove coast and sabatuun to pest
		transfer_region("wh2_main_headhunters_jungle_mangrove_coast", "wh2_main_skv_clan_pestilens", 2, false);
		transfer_region("wh2_main_southern_great_jungle_subatuun", "wh2_main_skv_clan_pestilens", 2, false);
	end
	
	-- confed mazda with nakai
	confed("wh2_main_lzd_hexoatl", "wh2_dlc13_lzd_spirits_of_the_jungle", false);
	
	-- war mazda with wulfheart 
	force_war("wh2_main_lzd_hexoatl", "wh2_dlc13_emp_the_huntmarshals_expedition", false);
	
	-- trade wulfheart with empire
	make_trade_agreement("wh2_dlc13_emp_the_huntmarshals_expedition", "wh_main_emp_empire", false);
	
	-- peace wulfheart blue vipers
	force_peace("wh2_dlc13_emp_the_huntmarshals_expedition", "wh2_main_grn_blue_vipers", false);
	
	-- war wulfheart tlaxtlan
	force_war("wh2_dlc13_emp_the_huntmarshals_expedition", "wh2_main_lzd_tlaxtlan", false);
	
	-- peace mazda blue vipers
	force_peace("wh2_main_lzd_hexoatl", "wh2_main_grn_blue_vipers", false)
	
	-- skeggi trade with wulfrik
	make_trade_agreement("wh2_main_nor_skeggi", "wh_dlc08_nor_norsca", false);
	
	-- new world colonies trade with estalia
	make_trade_agreement("wh2_main_emp_new_world_colonies", "wh_main_teb_estalia", false);

end

local function setup_ulthuan()
	
	-- confed imrik with caledor
	confed("wh2_dlc15_hef_imrik", "wh2_main_hef_caledor", false);
	
	-- confed teclis with loremasters
	confed("wh2_main_hef_order_of_loremasters", "wh2_main_hef_saphery", false);
	
	-- war alith anar with scourge of khaine
	force_war("wh2_main_hef_nagarythe", "wh2_main_def_scourge_of_khaine", false);
	
	-- no war tyrion teclis eltharion alarielle
	force_no_war("wh2_main_hef_high_elves", "wh2_main_hef_avelorn", false);
	force_no_war("wh2_main_hef_high_elves", "wh2_main_hef_order_of_loremasters", false);
	force_no_war("wh2_main_hef_high_elves", "wh2_main_hef_yvresse", false);
	
	force_no_war("wh2_main_hef_avelorn", "wh2_main_hef_order_of_loremasters", false);
	force_no_war("wh2_main_hef_avelorn", "wh2_main_hef_yvresse", false);
	
	force_no_war("wh2_main_hef_order_of_loremasters", "wh2_main_hef_yvresse", false);
end

local function setup_nagarond()
	-- confed lokhir with karon kar
	confed("wh2_dlc11_def_the_blessed_dread", "wh2_main_def_karond_kar", false);
	
	-- give har grief to malus
	transfer_region("wh2_main_the_black_flood_hag_graef", "wh2_main_def_hag_graef", 0, false);
end

local function setup_empire()
	-- peace empire with skullshmasherz
	
	-- war empire with black venom
	
	-- war empire skull takerz
	
	-- peace angrund skull takerz
	
	-- give aarnau to leaf cutterz
	
	-- war drycha talabheim
	
end

local function setup_norsca()

	-- confed norsca with skaeling
	
	-- confed wintertooth with naglafarlings
	
	-- war wulfrik with nordland
	
	-- war wintertooth with kislev
	
end

local function setup_sylvania()
	
	local player_is_mannfred = faction_is_human("wh_main_vmp_vampire_counts");
	
	if not player_is_mannfred then
		-- give castle templehof to vlad
		transfer_region("wh_main_western_sylvania_castle_templehof", "wh_main_vmp_schwartzhafen", 0, false);
		
		-- give fort oberstyre to vlad	
		transfer_region("wh_main_western_sylvania_fort_oberstyre", "wh_main_vmp_schwartzhafen", 0, false);
	end
	
end

local function setup_bretonia()
	-- peace wulfric and brettonia
	
end

local function setup_nehekhara()
	-- war repanse with arkhan
	
	-- alliance repanse with lyonnaise
	
	-- give zandri to khmri
	
	-- peace khemri with top knotz
	
	-- war khmri with necrath brotherhood
end

local function setup_badlands()
	
	-- confed grom with skull crag
	
	-- confed mannfred with strygos empire
	
end

local function setup_darklands()
	-- war malus with imrik
	
	-- confed riktus with clan nest
end

local function setup_worlds_edge_mountains()
	-- peace karaz-a-karak with white hand
	
	-- peace karaz-a-karak with scabey eyes
	
	-- peace karaz-a-karak with red fangs
end

local function setup_player_mazda()
	--# assume mazda starts with kroq nakai and tiktaktoe
	local player_is_mazda = faction_is_human("wh2_main_lzd_hexoatl");
	
	if player_is_mazda then	
		-- destroy temple of skulls
		abandon_region("wh2_main_kingdom_of_beasts_temple_of_skulls", "wh2_main_lzd_last_defenders", false)
		
		-- kill last defenders characters
		kill_faction_armies("wh2_main_lzd_last_defenders");
		
		-- destroy jaluk oasis
		abandon_region("wh2_main_western_jungles_tlaqua", "wh2_main_lzd_tlaqua", false)
		
		-- kill tlaqa characters
		kill_faction_armies("wh2_main_lzd_tlaqua");
	end
	
end

local function setup_player_tyrion()
	--# assume tyrion starts with teclis
	local player_is_tyrion = faction_is_human("wh2_main_hef_eataine");
	
	if player_is_tyrion then
		-- destroy star tower
		abandon_region("wh2_main_volcanic_islands_the_star_tower", "wh2_main_hef_order_of_loremasters", false)
		
		-- kill order of loremaster characters	
		kill_faction_armies("wh2_main_hef_order_of_loremasters");
	end
	
end

local function setup_player_karl()
	--# assume karl starts with gelt
	local player_is_karl = faction_is_human("wh_main_emp_empire");
	
	if player_is_karl then
		-- give pfeil dorf to black venom
		transfer_region("wh2_main_solland_pfeildorf", "wh_main_grn_black_venom", 0, false);
		
		-- give fort soll to wissen land
		transfer_region("wh2_main_fort_soll", "wh_main_emp_wissenland", 0, false);
		
		-- kill golden order characters
		kill_faction_armies("wh2_dlc13_emp_golden_order");
	end	
end

local function setup_player_mannfred()
	--# assume mannfred starts with vlad
	local player_is_mannfred = faction_is_human("wh_main_vmp_vampire_counts");
	
	if player_is_mannfred then
		-- give shwartzhafen to templehof
		transfer_region("wh_main_western_sylvania_schwartzhafen", "wh_main_vmp_rival_sylvanian_vamps", 0, false);
		
		-- kill von carsteins characters
		kill_faction_armies("wh_main_vmp_schwartzhafen");
	end
end

local function change_mortal_empires()
	setup_undead_alliance();
	setup_8_peaks();
	setup_lustria();
	setup_ulthuan();
	setup_nagarond();
	setup_empire();
	setup_norsca();
	setup_sylvania();
	setup_bretonia();
	setup_nehekhara();
	setup_badlands();
	setup_darklands();
	setup_worlds_edge_mountains();
end

function nayran_wh2_campaign_script()
	if cm:is_new_game() then
		disable_event_log(true);
		change_mortal_empires();
		disable_event_log(false);
	end;
end

core:add_listener(
	"nayran_extra_setup",
	"MctFinalized",
	true,
	function(context)		
		local mct = get_mct()
		local frosty_confeds_mod = mct:get_mod_by_key("frosty_confeds")
		local settings_table = frosty_confeds_mod:get_settings() 
		enable_value = settings_table._01_enableorDisable

		if enable_value then
			cm:callback(function()
				setup_player_mazda();
				setup_player_tyrion();
				setup_player_karl();
				setup_player_mannfred();
			end, 1)
		end
		core:remove_listener("frosty_confeds_MctFinalized_done");
	end,
	true
)