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
local function faction_is_human(current_faction)
	local faction = cm:get_faction(current_faction);
	local is_human = faction:is_human();
	return is_human;
end

--# assume kill_faction_armies: method(faction_name: string)
local function kill_faction_armies(faction_name)
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
		local declarer_is_human = faction_is_human(declarer);
		local declaree_is_human = faction_is_human(declaree);
		if declarer_is_human or declaree_is_human then
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
	local confederate_factions = apply_diplomacy(confederator, confederated, apply_to_player);
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

--# assume add_building_to_region: method(region: string, building: string, ownder_faction: string, apply_to_player: boolean)
local function add_building_to_region(region, building, owner_faction, apply_to_player)
    local add_building = true;
	if apply_to_player == false then
		local target_is_human = faction_is_human(owner_faction);
		if target_is_human then
			add_building = false;
		end
	end
	if add_building == true then
		cm:add_building_to_settlement(region, building);
		heal_garrison(region);
	end
end

--# assume transfer_region: method(region: string, faction: string, level: integer, apply_to_player: boolean)
local function transfer_region(region, faction, level, apply_to_player)
	local transfer = true;
	if apply_to_player == false then
		local target_is_human = faction_is_human(faction);
		if target_is_human then
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
	if apply_to_player == false then
		local target_is_human = faction_is_human(initial_faction);
		if target_is_human == true then
			abandon = false;
		end
	end
	if abandon == true then
		cm:set_region_abandoned(region);
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
		
		-- confed pestilens with mange
		confed("wh2_main_skv_clan_pestilens", "wh2_dlc12_skv_clan_mange", false);
	end
	
	-- war clan mange vs itza
	confed("wh2_dlc12_skv_clan_mange", "wh2_dlc12_skv_clan_mange", false);
	
	-- war xeti vs lustria dwarfs
	force_war("wh2_main_lzd_sentinels_of_xeti", "wh2_main_dwf_spine_of_sotek_dwarfs", false);
	
	-- confed mazda with nakai
	confed("wh2_main_lzd_hexoatl", "wh2_dlc13_lzd_spirits_of_the_jungle", false);
	
	-- war mazda with wulfheart 
	force_war("wh2_main_lzd_hexoatl", "wh2_dlc13_emp_the_huntmarshals_expedition", false);
	
	-- peace wulfheart blue vipers
	force_peace("wh2_dlc13_emp_the_huntmarshals_expedition", "wh2_main_grn_blue_vipers", false);
	
	-- war wulfheart tlaxtlan
	force_war("wh2_dlc13_emp_the_huntmarshals_expedition", "wh2_main_lzd_tlaxtlan", false);
	
	-- peace mazda blue vipers
	force_peace("wh2_main_lzd_hexoatl", "wh2_main_grn_blue_vipers", false)
	
	-- trade wulfheart with empire
	make_trade_agreement("wh2_dlc13_emp_the_huntmarshals_expedition", "wh_main_emp_empire", false);
	
	-- skeggi trade with wulfrik
	make_trade_agreement("wh2_main_nor_skeggi", "wh_dlc08_nor_norsca", false);
	
	-- new world colonies trade with estalia
	make_trade_agreement("wh2_main_emp_new_world_colonies", "wh_main_teb_estalia", false);
	
	-- felheart trade with karon kar
	make_trade_agreement("wh2_dlc11_def_the_blessed_dread", "wh2_main_def_karond_kar", false);

end

local function setup_ulthuan()
	
	-- no war tyrion teclis eltharion alarielle
	force_no_war("wh2_main_hef_eataine", "wh2_main_hef_avelorn", false);
	force_no_war("wh2_main_hef_eataine", "wh2_main_hef_order_of_loremasters", false);
	force_no_war("wh2_main_hef_eataine", "wh2_main_hef_yvresse", false);
	
	force_no_war("wh2_main_hef_avelorn", "wh2_main_hef_order_of_loremasters", false);
	force_no_war("wh2_main_hef_avelorn", "wh2_main_hef_yvresse", false);
	
	force_no_war("wh2_main_hef_order_of_loremasters", "wh2_main_hef_yvresse", false);
end

local function setup_empire()
	-- peace empire with skullshmasherz
	force_peace("wh_main_emp_empire", "wh_main_grn_skullsmasherz", false);
	
	-- war empire with black venom
	force_war("wh_main_emp_empire", "wh_main_grn_black_venom", false);
	
	-- war empire skull takerz
	force_war("wh_main_emp_empire", "wh_main_grn_skull-takerz", false);
	
	-- peace angrund skull takerz
	force_peace("wh_main_dwf_karak_izor", "wh_main_grn_skull-takerz", false);
	
	-- peace boris leaf cutterz
	force_peace("wh_main_emp_middenland", "wh2_dlc12_grn_leaf_cutterz_tribe", false);
	
	-- war boris red horn
	force_war("wh_main_emp_middenland", "wh_dlc03_bst_redhorn", false);
	
	-- give aarnau to leaf cutterz
	transfer_region("wh_main_the_wasteland_aarnau", "wh2_dlc12_grn_leaf_cutterz_tribe", 0, false);
	
	-- war drycha talabheim
	force_war("wh2_dlc16_wef_drycha", "wh_main_emp_talabecland", false);
	
end

local function setup_norsca()

	-- confed norsca with skaeling
	confed("wh_dlc08_nor_norsca", "wh_main_nor_skaeling", false);
	
	-- confed wintertooth with naglafarlings
	confed("wh_dlc08_nor_wintertooth", "wh_dlc08_nor_naglfarlings", false);
	
	-- war wulfrik with nordland
	force_war("wh_dlc08_nor_norsca", "wh_main_emp_nordland", false);
	
	-- war wintertooth with kislev
	force_war("wh_dlc08_nor_wintertooth", "wh_main_ksl_kislev", false);
	
end

local function setup_sylvania()
	
	local player_is_mannfred = faction_is_human("wh_main_vmp_vampire_counts");
	
	abandon_region("wh_main_eastern_sylvania_castle_drakenhof", "wh_main_vmp_vampire_counts", false);
	transfer_region("wh_main_eastern_sylvania_castle_drakenhof", "wh_main_vmp_vampire_counts", 2, false);
	add_building_to_region("wh_main_eastern_sylvania_castle_drakenhof", "wh_main_vmp_cemetary_2", "wh_main_vmp_vampire_counts", false);
	
	abandon_region("wh_main_eastern_sylvania_eschen", "wh_main_vmp_vampire_counts", false);
	transfer_region("wh_main_eastern_sylvania_eschen", "wh_main_vmp_vampire_counts", 1, false);
	
	if not player_is_mannfred then
		-- give castle templehof to vlad
		transfer_region("wh_main_western_sylvania_castle_templehof", "wh_main_vmp_schwartzhafen", 0, false);
		
		-- give fort oberstyre to vlad	
		transfer_region("wh_main_western_sylvania_fort_oberstyre", "wh_main_vmp_schwartzhafen", 0, false);
		abandon_region("wh_main_western_sylvania_fort_oberstyre", "wh_main_vmp_schwartzhafen", false);
		transfer_region("wh_main_western_sylvania_fort_oberstyre", "wh_main_vmp_schwartzhafen", 2, false);
		add_building_to_region("wh_main_western_sylvania_fort_oberstyre", "wh_main_vmp_cemetary_2", "wh_main_vmp_schwartzhafen", false);
	end
	
	force_defensive_alliance("wh_main_vmp_vampire_counts", "wh_main_vmp_schwartzhafen", false);
	
end

local function setup_bretonia()
	-- peace wulfric and brettonia
	force_peace("wh_dlc08_nor_norsca", "wh_main_brt_bretonnia", false);
end

local function setup_nehekhara()	
	-- trade repanse with lyonnaise
	make_trade_agreement("wh2_dlc14_brt_chevaliers_de_lyonesse", "wh_main_brt_lyonesse", false);
	
	-- give zandri to khmri
	transfer_region("wh2_main_land_of_the_dead_zandri", "wh2_dlc09_tmb_khemri", 2, false);
	
	-- peace khemri with top knotz
	force_peace("wh2_dlc09_tmb_khemri", "wh_main_grn_top_knotz", false);
	
	-- peace khemri with arkhan
	force_peace("wh2_dlc09_tmb_khemri", "wh2_dlc09_tmb_followers_of_nagash", false);
end

local function setup_badlands()
	
	-- confed grom with skull crag
	confed("wh2_dlc15_grn_broken_axe", "wh2_dlc15_grn_skull_crag", false);
	
end

local function setup_darklands()	
	-- confed riktus with clan nest
	confed("wh2_dlc09_skv_clan_rictus", "wh2_dlc14_skv_rictus_clan_nest", false);
	
	-- war neferata vs khalida
	force_war("wh2_dlc16_vmp_lahmian_sisterhood", "wh2_dlc09_tmb_lybaras", false);
	
	-- millitary alliance neferata vs silver host
	force_millitary_alliance("wh2_dlc16_vmp_lahmian_sisterhood", "wh2_main_vmp_the_silver_host", false);
end

local function setup_worlds_edge_mountains()
	-- peace karaz-a-karak with bloody hand
	force_peace("wh_main_dwf_dwarfs", "wh_main_grn_orcs_of_the_bloody_hand", false);
	
	-- peace karaz-a-karak with scabey eyes
	force_peace("wh_main_dwf_dwarfs", "wh_main_grn_scabby_eye", false);
	
	-- peace karaz-a-karak with red fangs
	force_peace("wh_main_dwf_dwarfs", "wh_main_grn_red_fangs", false);
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
	setup_8_peaks();
	setup_lustria();
	setup_ulthuan();
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
				setup_player_karl();
				setup_player_mannfred();
			end, 1)
		end
		core:remove_listener("frosty_confeds_MctFinalized_done");
	end,
	true
)