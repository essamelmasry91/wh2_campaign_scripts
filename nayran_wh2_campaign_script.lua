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

local function heal_garrisons()
    local faction_list = cm:model():world():faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local current_faction = faction_list:item_at(i)
        local region_list = current_faction:region_list()
        for i = 0, region_list:num_items() - 1 do
            local current_region = region_list:item_at(i)
            local current_region_cqi = current_region:cqi()
            cm:heal_garrison(current_region_cqi)
        end
    end
end

--# assume faction_is_human: method(faction: string)
local function faction_is_human(faction)
	return cm:get_faction(faction):is_human();
end

--# assume apply_diplomacy: method(declarer: string, declaree: string, apply_to_player: boolean)
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

--# assume transfer_region: method(region: string, faction: string, apply_to_player: boolean)
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

local function setup_8_peaks_conflict()
	-- angrund, mors and crooked moon at war
	force_war("wh2_main_skv_clan_mors", "wh_main_grn_crooked_moon", true);
	force_war("wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor", true);

	-- give 8 peaks to skarsnik
	confed("wh_main_grn_crooked_moon", "wh_main_grn_necksnappers", false);	
end

local function change_mortal_empires()
	setup_8_peaks_conflict();
	heal_garrisons()
end

function nayran_wh2_campaign_script()
	if cm:is_new_game() then
		change_mortal_empires();
	end;
end