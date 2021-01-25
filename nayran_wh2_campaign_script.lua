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

local function setup_undead_alliance()
	
	--#assume player isnt one of those factions
	
	-- military alliance between dreadfleet arkhan mannfred lahmia sisterhood and silver host
	
	-- defensive alliance between vlad and mannfred
	
	-- war on sentinels
	
	-- war on khmeri
	
	-- war on lybaras
	
end

local function setup_8_peaks()
	-- angrund, mors and crooked moon at war
	force_war("wh2_main_skv_clan_mors", "wh_main_grn_crooked_moon", true);
	force_war("wh2_main_skv_clan_mors", "wh_main_dwf_karak_izor", true);

	-- give 8 peaks to skarsnik
	confed("wh_main_grn_crooked_moon", "wh_main_grn_necksnappers", false);	
end

local function setup_lustria() 
	
	-- war felheart and teclis
	force_war("wh2_dlc11_def_the_blessed_dread", "wh2_main_hef_order_of_loremasters", false);
	
	-- confed pestilence with mange
	
	-- confed mazda with nakai
	
	-- war mazda with wulfheart 
	
	-- give pox march to Vampirates
	
	-- peace wulfheart blue vipers
	
	-- war wulfheart tlaxtlan
	
	-- alliance wulfheart with empire
	
	-- trade wulfheart with empire
	
	-- skeggi trade with vanaheimlings
	
	-- new world colonies trade with estalia

end

local function setup_ulthuan()
	
	-- confed imrik with caledor
	
	-- confed teclis with loremasters
	
	-- war alith anar with scourge of khaine
	
	-- no war tyrion teclis eltharion alith anar alarielle
end

local function setup_nagarond()
	-- confed lokhir with karon kar
	
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
	--# assume player is not mannfred
	
	-- give castle templehof to vlad
	
	-- give fort obrion to vlad	
	
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
	
	-- kill spirit of the jungle characters
	
	-- destroy temple of skulls
	
	-- kill last defenders characters
	
	-- destroy jaluk oasis
	
	-- kill tlaqa characters
	
end

local function setup_player_tyrion()
	--# assume tyrion starts with teclis
	
	-- destroy star tower

	-- kill order of loremaster characters	
	
end

local function setup_player_grimgor()
	--# assume grimgor starts with wuzzag
	
	-- give ekrund to teef snatchaz
	
	-- kill white hand characters
	
end

local function setup_player_karl()
	--# assume karl starts with gelt
	
	-- give pfeil dorf to black venom
	
	-- give fort soll to wissen land
	
	-- kill golden order characters
	
end

local function setup_player_mannfred()
	--# assume mannfred starts with vlad
	
	-- give shwartzhafen to templehof
	
	-- give von carsteins characters
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
	setup_player_mazda();
	setup_player_tyrion();
	setup_player_grimgor();
	setup_player_karl();
	setup_player_mannfred();
	heal_garrisons();
end

function nayran_wh2_campaign_script()
	if cm:is_new_game() then
		change_mortal_empires();
	end;
end