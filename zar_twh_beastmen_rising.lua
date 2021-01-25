-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--BEASTMEN RISING SCRIPT for Mortal Empires
--by Zarkis aka Yarkis de Bodemlooze
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

-- all playable bst factions 
BEASTMEN_FACTIONS = {"wh_dlc03_bst_beastmen","wh_dlc03_bst_redhorn","wh_dlc03_bst_jagged_horn","wh2_main_bst_blooded_axe","wh2_main_bst_manblight","wh2_main_bst_ripper_horn","wh2_main_bst_shadowgor"}

-- BST_TRIBE_REGIONS[2]: Messages displayed
-- BST_TRIBE_REGIONS[3]: 1 = Khorn, north; 2 = Tzeentch, middle 3 = Nurgle, south; 4 = Slaanesh, Naggaroth
BST_TRIBE_REGIONS = {
				{"wh2_main_aghol_wastelands_the_palace_of_ruin", 0, 4, 0},
				{"wh2_main_atalan_mountains_eye_of_the_panther", 0, 0, 0},
				{"wh2_main_blackspine_mountains_plain_of_spiders", 0, 4, 0},
				{"wh2_main_deadwood_shagrath", 0, 4, 0},
				{"wh2_main_doom_glades_hag_hall", 0, 4, 0},
				{"wh2_main_doom_glades_ice_rock_gorge", 0, 4, 0},
				{"wh2_main_doom_glades_temple_of_addaioth", 0, 4, 0},
				{"wh2_main_great_desert_of_araby_el-kalabad", 0, 0, 0},
				{"wh2_main_iron_mountains_rackdo_gorge", 0, 4, 4},
				{"wh2_main_ironfrost_glacier_dagraks_end", 0, 4, 0},
				{"wh2_main_kingdom_of_beasts_serpent_coast", 0, 3, 0},
				{"wh2_main_kingdom_of_beasts_temple_of_skulls", 0, 3, 0},
				{"wh2_main_kingdom_of_beasts_the_cursed_jungle", 0, 3, 3},
				{"wh2_main_obsidian_peaks_clar_karond", 0, 4, 0},
				{"wh2_main_southlands_jungle_teotiqua", 0, 3, 0},
				{"wh2_main_southlands_jungle_golden_tower_of_the_gods", 0, 3, 0},
				{"wh2_main_southlands_worlds_edge_mountains_lost_plateau", 0, 3, 0},
				{"wh2_main_the_black_flood_cragroth_deep", 0, 4, 0},
				{"wh2_main_the_black_flood_shroktak_mount", 0, 4, 0},
				{"wh2_main_the_black_flood_temple_of_khaine", 0, 4, 0},
				{"wh2_main_the_chill_road_ashrak", 0, 4, 0},
				{"wh2_main_the_road_of_skulls_kauark", 0, 4, 0},
				{"wh2_main_the_road_of_skulls_spite_reach", 0, 4, 0},
				{"wh2_main_titan_peaks_ancient_city_of_quintex", 0, 4, 0},
				{"wh_main_blightwater_deff_gorge", 0, 0, 0},
				{"wh_main_blightwater_karak_azgal", 0, 0, 0},
				{"wh_main_bordeleaux_et_aquitaine_aquitaine", 0, 2, 0},
				{"wh_main_chaos_wastes", 0, 0, 0},
				{"wh_main_desolation_of_nagash_spitepeak", 0, 0, 0},
				{"wh_main_estalia_magritta", 0, 2, 0},
				{"wh_main_estalia_tobaro", 0, 2, 0},
				{"wh_main_forest_of_arden_castle_artois", 0, 2, 2},
				{"wh_main_gianthome_mountains_sjoktraken", 0, 1, 0},
				{"wh_main_helspire_mountains_serpent_jetty", 0, 1, 1},
				{"wh_main_hochland_brass_keep", 0, 0, 0},
				{"wh_main_hochland_hergig", 0, 0, 0},
				{"wh_main_lyonesse_lyonesse", 0, 2, 0},
				{"wh_main_middenland_carroburg", 0, 0, 0},
				{"wh_main_middenland_middenheim", 0, 0, 0},
				{"wh_main_mountains_of_hel_aeslings_conclave", 0, 1, 0},
				{"wh_main_mountains_of_naglfari_naglfari_plain", 0, 1, 0},
				{"wh_main_nordland_dietershafen", 0, 0, 0},
				{"wh_main_nordland_salzenmund", 0, 0, 0},
				{"wh_main_ostermark_bechafen", 0, 2, 0},
				{"wh_main_ostland_norden", 0, 2, 0},
				{"wh_main_parravon_et_quenelles_parravon", 0, 2, 0},
				{"wh_main_parravon_et_quenelles_quenelles", 0, 2, 0},
				{"wh_main_reikland_eilhart", 0, 0, 0},
				{"wh_main_southern_badlands_galbaraz", 0, 0, 0},
				{"wh_main_southern_badlands_agrul_migdhal", 0, 0, 0},
				{"wh_main_talabecland_kemperbad", 0, 2, 0},
				{"wh_main_talabecland_talabheim", 0, 2, 0},
				{"wh_main_trollheim_mountains_the_tower_of_khrakk", 0, 1, 0},
				{"wh_main_vanaheim_mountains_pack_ice_bay", 0, 1, 0},
				{"wh_main_western_badlands_dragonhorn_mines", 0, 0, 0},
				{"wh_main_zhufbar_karag_dromar", 0, 0, 0},
				{"wh2_main_shifting_sands_antoch", 0, 0, 0}
				};


function zar_twh_beastmen_rising()

		if cm:model():campaign_name("main_warhammer") then

			if BST_TRIBE_REGIONS[1][2] == 0 then
				beastmen_setup()
			end;

			if cm:get_saved_value("zar_bst_player_choice") == nil then
				player_dilemma_listener();
			end;

			setup_bst_tribes_region_monitor();
			beastmen_uprising_listeners();

		end;

end


function beastmen_setup() 

	local game_interface = cm:get_game_interface();

	for i = 1, #BST_TRIBE_REGIONS do
		game_interface:apply_effect_bundle_to_region("zar_bst_region_bst_tribes", BST_TRIBE_REGIONS[i][1], 0);
		BST_TRIBE_REGIONS[i][2] = 1;
	end;

	local beastmen_missions = {"zar_bst_mission_great_herdstone_khorne","zar_bst_mission_great_herdstone_nurgle","zar_bst_mission_great_herdstone_tzeentch","zar_bst_mission_great_herdstone_slaanesh"}
	local beastmen_missions_region = {"wh_main_helspire_mountains_serpent_jetty","wh2_main_kingdom_of_beasts_the_cursed_jungle","wh_main_forest_of_arden_castle_artois","wh2_main_iron_mountains_rackdo_gorge"}
	local beastmen_missions_payloads = {"khorne_dummy","nurgle_dummy","tzeentch_dummy","slaanesh_dummy"}

	for i = 1, #BEASTMEN_FACTIONS do 
		local faction = cm:get_faction(BEASTMEN_FACTIONS[i]);
		if faction:is_human() then
			local k = 0
			for j = 1, #beastmen_missions do 
				k = k + 1
				local mm = mission_manager:new(BEASTMEN_FACTIONS[i], beastmen_missions[j]);
				mm:add_new_objective("MOVE_TO_REGION");
				mm:set_mission_issuer("CLAN_ELDERS");
				mm:add_condition("region " .. beastmen_missions_region[j]);
				mm:add_payload("effect_bundle{bundle_key zar_bst_payload_great_herdstone_" .. beastmen_missions_payloads[j] .. ";turns 1;}");
				mm:set_should_whitelist(false);
				mm:trigger();
			end;
		end;
	end;

end


function player_dilemma_listener()

		core:add_listener(
			"BST_CHS_Player_DilemmaChoiceMadeEvent",
			"DilemmaChoiceMadeEvent",
			true,
			function(context)
				local dilemma = context:dilemma();
				local choice = context:choice();
				local bst = cm:get_faction("wh_dlc03_bst_beastmen");
				if dilemma == "zar_bst_dilemma_player_choice" then
					if choice == 1 then
						cm:set_saved_value("zar_bst_player_choice", 0);
					elseif choice == 0 then
						beastmen_uprising_listeners()
						if bst:is_human() then 
							cm:set_saved_value("zar_bst_player_choice", 1);
						else
							cm:set_saved_value("zar_bst_player_choice", 2);
						end	
					end
				end;
			end,
			true
		);

end;


-- Beastmen invasion function
function beastmen_uprising_listeners()

	core:add_listener(
		"beastmen_uprising",
		"FactionRoundStart",
		function(context)
			local human_factions = cm:get_human_factions();
			return context:faction():name() == human_factions[1];
		end,
		function()
			bst_uprising_player_turn()
		end,
		true
	);

end


function bst_uprising_player_turn()

	local turn_number = cm:model():turn_number();

	if cm:get_saved_value("zar_bst_player_choice") == nil or (not cm:get_saved_value("zar_bst_player_choice")) then 
		return
	end

	if cm:get_saved_value("zar_bst_player_choice") > 0 then

		if cm:get_saved_value("beastmen_uprising_stage") == nil then
			if 40 < turn_number then
				cm:set_saved_value("beastmen_uprising_stage", 2);
				cm:set_saved_value("bst_uprising_armies_max", 5);
			else
				cm:set_saved_value("beastmen_uprising_stage", 0);
				cm:set_saved_value("bst_uprising_armies_max", 0);
			end;
		end;

		if cm:get_saved_value("beastmen_uprising_stage") == 1 then
			if cm:get_saved_value("bst_uprising_armies_max") < 5 then 
				bst_uprising_spawn_army();
			else
				cm:set_saved_value("beastmen_uprising_stage", 2);
			end;
		end;

		if cm:get_saved_value("beastmen_uprising_stage") == 3 then 
			if cm:get_saved_value("bst_uprising_armies_max") < 12 then
				bst_uprising_spawn_army();
			else
				core:remove_listener("beastmen_uprising") ;
			end;
		end;

		if cm:get_saved_value("beastmen_uprising_stage") == 0 then 
			if 50 < turn_number + cm:random_number(20, 1) then
			--if 3 < turn_number + cm:random_number(1, 1) then
				announce_bst_uprising();
				cm:set_saved_value("beastmen_uprising_stage", 1);
			end;
		elseif cm:get_saved_value("beastmen_uprising_stage") == 2 then
			if 150 < turn_number + cm:random_number(50, 1) then
			--if 10 < turn_number + cm:random_number(2, 1) then
				announce_bst_uprising();
				cm:set_saved_value("beastmen_uprising_stage", 3);
			end;
		end;

	end;

end


function announce_bst_uprising()

	local human_factions = cm:get_human_factions();
	
	for i = 1, #human_factions do

		if cm:get_saved_value("beastmen_uprising_stage") < 2 then
			cm:show_message_event_located(
				human_factions[i],
				"event_feed_strings_text_wh_event_feed_string_scripted_event_beastmen_tw_uprising_primary_detail",
				"",
				"event_feed_strings_text_wh_event_feed_string_scripted_event_beastmen_tw_uprising_secondary_detail",
				500,
				450,
				true,
				102
			);
		else
			cm:show_message_event_located(
				human_factions[i],
				"event_feed_strings_text_wh_event_feed_string_scripted_event_beastmen_tw_uprising2_primary_detail",
				"",
				"event_feed_strings_text_wh_event_feed_string_scripted_event_beastmen_tw_uprising2_secondary_detail",
				500,
				450,
				true,
				102
			);
		end;
	end;
end


function bst_uprising_spawn_army()

	local red_horn_spawn_points = {
		{721, 503, "wh_main_northern_worlds_edge_mountains_karak_ungor"},
		{664, 535, "wh_main_southern_oblast_kislev"},
		{558, 408, "wh_main_averland_averheim"},
		{604, 604, "wh_main_troll_country_zoishenk"},
		{618, 492, "wh_main_talabecland_talabheim"},
		{697, 490, "wh_main_ostermark_bechafen"},
		{450, 530, "wh_main_the_wasteland_marienburg"},
		{393, 563, "wh_main_vanaheim_mountains_pack_ice_bay"},
		{527, 663, "wh_main_mountains_of_naglfari_naglfari_plain"},
		{538, 608, "wh_main_ice_tooth_mountains_longship_graveyard"}
	};

	local possible_spawn_points = {
		{664, 535, "wh_main_southern_oblast_kislev"},
		{558, 408, "wh_main_averland_averheim"},
		{604, 604, "wh_main_troll_country_zoishenk"},
		{618, 492, "wh_main_talabecland_talabheim"},
		{676, 454, "wh_main_eastern_sylvania_waldenhof"},
		{526, 327, "wh_main_the_vaults_karak_izor"},
		{486, 438, "wh_main_reikland_altdorf"},
		{519, 516, "wh_main_middenland_middenheim"},
		{697, 490, "wh_main_ostermark_bechafen"},
		{450, 530, "wh_main_the_wasteland_marienburg"},
		{415, 318, "wh_main_carcassone_et_brionne_castle_carcassonne"},
		{416, 398, "wh_main_bastonne_et_montfort_castle_bastonne"},
		{630, 342, "wh_main_eastern_border_princes_akendorf"},
		{370, 261, "wh_main_estalia_magritta"},
		{393, 563, "wh_main_vanaheim_mountains_pack_ice_bay"},
		{527, 663, "wh_main_mountains_of_naglfari_naglfari_plain"},
		{538, 608, "wh_main_ice_tooth_mountains_longship_graveyard"}
	};

	local jagged_horn_spawn_points = {
		{572, 190, "wh_main_southern_badlands_galbaraz"},
		{747, 328, "wh_main_the_silver_road_mount_squighorn"},
		{772, 223, "wh_main_desolation_of_nagash_spitepeak"},
		{545, 164, "wh_main_southern_badlands_gor_gazan"},
		{630, 342, "wh_main_eastern_border_princes_akendorf"},
		{691, 195, "wh_main_blightwater_karak_azgal"}
	};

	local wh2_spawn_points = {
		{45, 704, "wh2_main_ironfrost_glacier_dagraks_end"},
		{180, 704, "wh2_main_the_road_of_skulls_kauark"},
		{395, 700, "wh2_main_aghol_wastelands_palace_of_princes"},
		{15, 565, "wh2_main_blackspine_mountains_red_desert"},
		{116, 546, "wh2_main_obsidian_peaks_circle_of_destruction"},
		{17, 498, "wh2_main_blackspine_mountains_plain_of_spiders"},
		{99, 462, "wh2_main_doom_glades_vauls_anvil"},
		{50, 361, "wh2_main_titan_peaks_ssildra_tor"},
		--{39, 247, "wh2_main_northern_jungle_of_pahualaxa_shrine_of_sotek"},
		--{76, 198, "wh2_main_southern_jungle_of_pahualaxa_floating_pyramid"},
		--{95, 79, "wh2_main_southern_great_jungle_itza"},
		--{200, 38, "wh2_main_headhunters_jungle_marks_of_the_old_ones"},
		{418, 87, "wh2_main_land_of_assassins_lashiek"},
		{507, 8, "wh2_main_great_desert_of_araby_el-kalabad"},
		{679, 120, "wh2_main_ash_river_quatar"},
		{872, 47, "wh2_main_southlands_jungle_golden_tower_of_the_gods"},
		{824, 156, "wh2_main_devils_backbone_lahmia"}
	};

	local bst_faction2_list = {"wh2_main_bst_blooded_axe","wh2_main_bst_manblight","wh2_main_bst_ripper_horn","wh2_main_bst_shadowgor"};
	local armies_spawned = cm:get_saved_value("bst_uprising_armies_max");
	local bst_faction = nil;
	local index = nil;
	local chosen_spawn_point = nil;

	-- semi-randomize factions
	if cm:get_saved_value("zar_bst_player_choice") == 1 then  --player is beastmen
		local bst_faction_list = {"wh_dlc03_bst_redhorn","wh_dlc03_bst_jagged_horn","wh_dlc03_bst_redhorn","wh_dlc03_bst_jagged_horn","wh2_main_bst_blooded_axe","wh2_main_bst_manblight","wh2_main_bst_ripper_horn","wh2_main_bst_shadowgor"};
		if armies_spawned == 1 or armies_spawned == 5 then
				bst_faction = "wh_dlc03_bst_redhorn";
			elseif armies_spawned == 3 or armies_spawned == 7 then
				bst_faction = "wh_dlc03_bst_jagged_horn";
			elseif armies_spawned == 0 or armies_spawned == 6 then
				index = cm:random_number(#bst_faction_list);
				bst_faction = bst_faction_list[index];
			elseif armies_spawned == 4 or armies_spawned == 8 then
				index = cm:random_number(#bst_faction2_list);
				bst_faction = bst_faction2_list[index];
			else
				index = cm:random_number(#bst_faction_list);
				bst_faction = bst_faction_list[index];
		end
	else
		local bst_faction_list = {"wh_dlc03_bst_beastmen","wh_dlc03_bst_beastmen","wh_dlc03_bst_redhorn","wh_dlc03_bst_jagged_horn","wh2_main_bst_blooded_axe","wh2_main_bst_manblight","wh2_main_bst_ripper_horn","wh2_main_bst_shadowgor"};
		if armies_spawned == 1 or armies_spawned == 5 then
			bst_faction = "wh_dlc03_bst_redhorn";
		elseif armies_spawned == 3 or armies_spawned == 7 then
			bst_faction = "wh_dlc03_bst_jagged_horn";
		elseif armies_spawned == 0 or armies_spawned == 6 then
			bst_faction = "wh_dlc03_bst_beastmen";
		elseif armies_spawned == 4 or armies_spawned == 8 then
			index = cm:random_number(#bst_faction2_list);
			bst_faction = bst_faction2_list[index];
		else
			index = cm:random_number(#bst_faction_list);
			bst_faction = bst_faction_list[index];
		end
	end;

	if bst_faction == "wh_dlc03_bst_jagged_horn" then
		index = cm:random_number(#jagged_horn_spawn_points);
		chosen_spawn_point = jagged_horn_spawn_points[index];
	elseif bst_faction == "wh_dlc03_bst_redhorn" then
		index = cm:random_number(#red_horn_spawn_points);
		chosen_spawn_point = red_horn_spawn_points[index];
	elseif bst_faction == "wh_dlc03_bst_beastmen" then
		index = cm:random_number(#possible_spawn_points);
		chosen_spawn_point = possible_spawn_points[index];
	else
		index = cm:random_number(#wh2_spawn_points);
		chosen_spawn_point = wh2_spawn_points[index];
	end;

	local x = chosen_spawn_point[1];
	local y = chosen_spawn_point[2];
	local region_name = chosen_spawn_point[3];

	local bst_uprising_horde_buildings = {{
		"wh_dlc03_horde_beastmen_herd_2",
		"wh_dlc03_horde_beastmen_gors_2",
		"wh_dlc03_horde_beastmen_minotaurs_1"},
		{"wh_dlc03_horde_beastmen_herd_3",
		"wh_dlc03_horde_beastmen_gors_3",
		"wh_dlc03_horde_beastmen_minotaurs_2"}};

	-- rank 2, 3, 4 | rank 10, 11, 12 
	bst_uprising_character_xp = {{900, 1900, 3000},{14660, 16240, 17820}};

	-- check if there is a character at that point, if so, return
	local faction_list = cm:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		local char_list = current_faction:character_list();
		
		for j = 0, char_list:num_items() - 1 do
			local current_char = char_list:item_at(j);
			if current_char:logical_position_x() == x and current_char:logical_position_y() == y then
				return;
			end;
		end;
	end;

	cm:create_force(
		bst_faction,
		get_scripted_army_string_tw(),
		region_name,
		x,
		y,
		true,
		function(cqi)
			show_spawned_army_event_bst(x, y);  
			cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 10, true);
			local char = cm:get_character_by_cqi(cqi);
			local mf_cqi = char:military_force():command_queue_index();
			if cm:get_saved_value("beastmen_uprising_stage") == 1 then
				cm:add_building_to_force(mf_cqi, bst_uprising_horde_buildings[1]);
				cm:add_agent_experience(cm:char_lookup_str(cqi), bst_uprising_character_xp[1][cm:random_number(3)]);
			else
				cm:add_building_to_force(mf_cqi, bst_uprising_horde_buildings[2]);
				cm:add_agent_experience(cm:char_lookup_str(cqi), bst_uprising_character_xp[2][cm:random_number(3)]);
			end;
		end
	);

	cm:set_saved_value("bst_uprising_armies_max", armies_spawned + 1);

end

function get_scripted_army_string_tw()

	local difficulty = cm:model():difficulty_level();
	
	local is_multiplayer = cm:is_multiplayer();

	local army_size = 10;

	if is_multiplayer then
		army_size = 10;				-- mp = normal (it's unsafe to rely on difficulty level, it can be different between clients)
	elseif difficulty == 0 then
		army_size = 10;				-- normal
	elseif difficulty == -1 then
		army_size = 11;				-- hard
	elseif difficulty == -2 then
		army_size = 12;				-- very hard
	elseif difficulty == -3 then
		army_size = 12;				-- legendary
	end;
	
	local army_string = "wh_dlc03_bst_inf_minotaurs_0,wh_dlc03_bst_inf_cygor_0,wh_dlc03_bst_inf_centigors_0";

	for i = 1, army_size do
		local unit_to_select = cm:random_number(100, 1);
		army_string = army_string .. ",";
		
		if cm:get_saved_value("beastmen_uprising_stage") == 1 then
			if unit_to_select <= 26 then
				army_string = army_string .. "wh_dlc03_bst_inf_ungor_herd_1";			-- 26%
			elseif unit_to_select <= 44 then
				army_string = army_string .. "wh_dlc03_bst_inf_ungor_raiders_0";		-- 18%
			elseif unit_to_select <= 62 then
				army_string = army_string .. "wh_dlc03_bst_inf_ungor_spearmen_0";		-- 18%
			elseif unit_to_select <= 75 then
				army_string = army_string .. "wh_dlc03_bst_inf_chaos_warhounds_0";		-- 13%
			elseif unit_to_select <= 85 then
				army_string = army_string .. "wh_dlc03_bst_inf_gor_herd_0";				-- 10%
			elseif unit_to_select <= 95 then
				army_string = army_string .. "wh_dlc03_bst_inf_gor_herd_1";				-- 10%
			else
				army_string = army_string .. "wh_dlc03_bst_inf_centigors_0";			-- 5%
			end;
		else
			if unit_to_select <= 15 then
				army_string = army_string .. "wh_dlc03_bst_inf_gor_herd_0";				-- 15%
			elseif unit_to_select <= 30 then
				army_string = army_string .. "wh_dlc03_bst_inf_gor_herd_1";				-- 15%
			elseif unit_to_select <= 40 then
				army_string = army_string .. "wh_dlc03_bst_inf_ungor_spearmen_1";		-- 10%
			elseif unit_to_select <= 45 then
				army_string = army_string .. "wh_dlc03_bst_inf_chaos_warhounds_1";		-- 5%
			elseif unit_to_select <= 55 then
				army_string = army_string .. "wh_dlc03_bst_inf_ungor_raiders_0";		-- 10%
			elseif unit_to_select <= 58 then
				army_string = army_string .. "wh_dlc03_bst_mon_chaos_spawn_0";			-- 3%
			elseif unit_to_select <= 65 then
				army_string = army_string .. "wh_dlc03_bst_inf_bestigor_herd_0";		-- 7%
			elseif unit_to_select <= 68 then
				army_string = army_string .. "wh_dlc03_bst_feral_manticore";			-- 3%
			elseif unit_to_select <= 72 then
				army_string = army_string .. "wh_dlc03_bst_inf_centigors_1";			-- 4%
			elseif unit_to_select <= 76 then
				army_string = army_string .. "wh_dlc03_bst_inf_centigors_2";			-- 4%
			elseif unit_to_select <= 80 then
				army_string = army_string .. "wh_dlc03_bst_inf_minotaurs_1";			-- 4%
			elseif unit_to_select <= 84 then
				army_string = army_string .. "wh_dlc03_bst_inf_minotaurs_2";			-- 4%
			elseif unit_to_select <= 88 then
				army_string = army_string .. "wh_dlc03_bst_inf_cygor_0";				-- 4%
			elseif unit_to_select <= 92 then
				army_string = army_string .. "wh_dlc05_bst_mon_harpies_0";				-- 4%
			elseif unit_to_select <= 96 then
				army_string = army_string .. "wh_dlc03_bst_mon_giant_0";				-- 4%
			else
				army_string = army_string .. "wh_dlc03_bst_cav_razorgor_chariot_0";		-- 4%
			end;
		end;
	end;

	return army_string;
end;

function show_spawned_army_event_bst(x, y)

	local human_factions = cm:get_human_factions();
	
	for i = 1, #human_factions do
	cm:show_message_event_located(
		human_factions[i],
		"event_feed_strings_text_wh_event_feed_string_scripted_event_beastmen_primary_detail",
		"",
		"event_feed_strings_text_wh_event_feed_string_scripted_event_beastmen_secondary_detail",
		x,
		y,
		true,
		102
		);
	end;

end;

--beastmen tribes and great herdstones
function setup_bst_tribes_region_monitor()
	
	core:add_listener(
		"bst_tribes_region_monitor",
		"CharacterTurnEnd",
		function(context) return context:character():faction():subculture() == "wh_dlc03_sc_bst_beastmen" end,
		function(context)
			local char = context:character();
			
			if char:has_region() then
				local x = char:logical_position_x();
				local y = char:logical_position_y();
				local region_name = char:region():name();
				local char_is_human = char:faction():is_human();
				local faction_name = char:faction():name();


				for i = 1, #BST_TRIBE_REGIONS do

					if char:character_type("general") then
						if region_name == BST_TRIBE_REGIONS[i][1] then
							cm:apply_effect_bundle_to_region("zar_bst_region_bst_tribes", BST_TRIBE_REGIONS[i][1], 0);
							cm:apply_effect_bundle_to_characters_force("zar_bst_payload_bst_tribes_support", char:cqi(), -1, true);
							if BST_TRIBE_REGIONS[i][2] ~= 2 and char_is_human then
								message_event_tribes_found(x, y, faction_name);
								BST_TRIBE_REGIONS[i][2] = 2;
							end;
						else
							cm:remove_effect_bundle_from_characters_force("zar_bst_payload_bst_tribes_support", char:cqi());
						end;
					end;

					if region_name == BST_TRIBE_REGIONS[i][1] and char_is_human then
						if BST_TRIBE_REGIONS[i][4] == 1 then
							cm:add_agent_experience(cm:char_lookup_str(char), 2000);
							cm:trigger_incident(faction_name, "zar_bst_incident_great_herdstone_khorne", true);
							BST_TRIBE_REGIONS[i][4] = 0;
						elseif BST_TRIBE_REGIONS[i][4] == 2 then
							cm:add_agent_experience(cm:char_lookup_str(char), 2000);
							cm:trigger_incident(faction_name, "zar_bst_incident_great_herdstone_tzeentch", true);
							BST_TRIBE_REGIONS[i][4] = 0;
						elseif BST_TRIBE_REGIONS[i][4] == 3 then
							cm:add_agent_experience(cm:char_lookup_str(char), 2000);
							cm:trigger_incident(faction_name, "zar_bst_incident_great_herdstone_nurgle", true);
							BST_TRIBE_REGIONS[i][4] = 0;
						elseif BST_TRIBE_REGIONS[i][4] == 4 then
							cm:add_agent_experience(cm:char_lookup_str(char), 2000);
							cm:trigger_incident(faction_name, "zar_bst_incident_great_herdstone_slaanesh", true);
							BST_TRIBE_REGIONS[i][4] = 0;
						end;
					end;

				end;
			end;

		end,
		true
	);

end;


function message_event_tribes_found(x, y, faction_name)
	cm:show_message_event_located(
		faction_name,
		"event_feed_strings_text_wh_event_feed_string_scripted_event_beastmen_tribes_found_primary_detail",
		"",
		"event_feed_strings_text_wh_event_feed_string_scripted_event_beastmen_tribes_found_secondary_detail",
		x,
		y,
		true,
		105
	);
end


cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("bst_tribe_regions", BST_TRIBE_REGIONS, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		BST_TRIBE_REGIONS = cm:load_named_value("bst_tribe_regions", BST_TRIBE_REGIONS, context);
	end
);