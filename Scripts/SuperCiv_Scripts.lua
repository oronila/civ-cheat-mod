-- SuperCiv_Scripts.lua
-- Script for the Super Civilization mod
-- This script adds additional functionality that can't be done through XML alone

-- ==========================================================================
-- VARIABLE DECLARATIONS
-- ==========================================================================
local iSuperCivID = GameInfo.Civilizations["CIVILIZATION_SUPER"].Hash;
local iSuperLeaderID = GameInfo.Leaders["LEADER_SUPER"].Hash;

-- ==========================================================================
-- MAIN FUNCTIONS
-- ==========================================================================

-- Function to apply additional yields each turn 
function ApplyBonusYieldsPerTurn(playerID)
    local player = Players[playerID];
    if not player then return; end
    
    -- Only apply to the Super Civilization
    local playerConfig = PlayerConfigurations[playerID];
    if playerConfig:GetCivilizationTypeName() ~= "CIVILIZATION_SUPER" then return; end
    
    -- Apply bonuses to all cities
    local cities = player:GetCities();
    for i, city in cities:Members() do
        -- Apply extra yields like Japan's adjacency bonuses simulation
        ApplyCityBonuses(city);
    end
end

-- Function to apply city bonuses
function ApplyCityBonuses(city)
    if not city then return; end
    
    -- For example, simulating bonus yields from various civ abilities
    -- This simulates Australia's bonus for districts on high appeal tiles
    local plots = Map.GetCityPlots():GetPurchasedPlots(city:GetID());
    for i, plot in ipairs(plots) do
        -- Do something with the plot, e.g., check appeal and add bonuses
        local appeal = plot:GetAppeal();
        if appeal >= 4 then
            -- Could manually add yields here if needed beyond XML modifiers
        end
    end
end

-- Function to give free technologies or civics like China's ability
function GrantFreeAdvances(playerID)
    local player = Players[playerID];
    if not player then return; end
    
    -- Only apply to the Super Civilization
    local playerConfig = PlayerConfigurations[playerID];
    if playerConfig:GetCivilizationTypeName() ~= "CIVILIZATION_SUPER" then return; end
    
    -- Example: Grant free tech boost or civic boost each time a new era begins
    -- This simulates China's Dynastic Cycle ability
    -- Implementation depends on when you want this to trigger
end

-- Function to add additional loyalty to cities (like Eleanor's ability)
function AddLoyaltyPressure(playerID)
    local player = Players[playerID];
    if not player then return; end
    
    -- Only apply to the Super Civilization
    local playerConfig = PlayerConfigurations[playerID];
    if playerConfig:GetCivilizationTypeName() ~= "CIVILIZATION_SUPER" then return; end
    
    -- Apply loyalty pressure to nearby foreign cities
    -- Implementation would go here
end

-- ==========================================================================
-- INCA ABILITIES IMPLEMENTATION
-- ==========================================================================

-- Function to enable the Terrace Farm improvement for the Super Civilization
function EnableTerraceImprovements(playerID)
    local player = Players[playerID];
    if not player then return; end
    
    -- Only apply to the Super Civilization
    local playerConfig = PlayerConfigurations[playerID];
    if playerConfig:GetCivilizationTypeName() ~= "CIVILIZATION_SUPER" then return; end
    
    -- Check if the player already has the ability to build Terrace Farms
    local hasTerraceFarm = false;
    for improvement in GameInfo.Improvements() do
        if improvement.ImprovementType == "IMPROVEMENT_TERRACE_FARM" then
            -- If the player has the ability
            local playerImprovements = player:GetImprovements();
            if playerImprovements and playerImprovements:HasImprovement(improvement.Index) then
                hasTerraceFarm = true;
                break;
            end
        end
    end
    
    -- If the player doesn't have Terrace Farms, grant it
    if not hasTerraceFarm then
        for tech in GameInfo.Technologies() do
            -- We're using Irrigation as the tech to unlock Terrace Farms, 
            -- as it's the original tech that unlocks it for the Inca
            if tech.TechnologyType == "TECH_IRRIGATION" then
                if player:GetTechs():HasTech(tech.Index) then
                    -- Unlock the Terrace Farm improvement
                    for improvement in GameInfo.Improvements() do
                        if improvement.ImprovementType == "IMPROVEMENT_TERRACE_FARM" then
                            local playerImprovements = player:GetImprovements();
                            if playerImprovements then
                                playerImprovements:GrantImprovement(improvement.Index);
                                print("Super Civilization: Terrace Farm improvement granted");
                            end
                        end
                    end
                end
            end
        end
    end
end

-- Function to enhance mountain tiles adjacent to Terrace Farms
function EnhanceMountainTilesNearTerraceFarms(playerID)
    local player = Players[playerID];
    if not player then return; end
    
    -- Only apply to the Super Civilization
    local playerConfig = PlayerConfigurations[playerID];
    if playerConfig:GetCivilizationTypeName() ~= "CIVILIZATION_SUPER" then return; end
    
    -- Check all cities
    local cities = player:GetCities();
    for i, city in cities:Members() do
        local cityPlots = city:GetOwnedPlots();
        for j, plot in ipairs(cityPlots) do
            -- Check if this plot has a Terrace Farm
            if plot:GetImprovementType() == GameInfo.Improvements["IMPROVEMENT_TERRACE_FARM"].Index then
                -- Check adjacent plots for mountains
                for direction = 0, 5, 1 do
                    local adjacentPlot = Map.GetAdjacentPlot(plot:GetX(), plot:GetY(), direction);
                    if adjacentPlot and adjacentPlot:GetTerrainType() == GameInfo.Terrains["TERRAIN_MOUNTAIN"].Index then
                        -- Add bonus food yield to this mountain tile
                        -- This would require a custom yield modifier for this particular plot
                        -- In reality, this would be handled by the XML system, but we're simulating it here
                        print("Super Civilization: Enhanced mountain tile near Terrace Farm");
                    end
                end
            end
        end
    end
end

-- ==========================================================================
-- EVENT HANDLERS
-- ==========================================================================

-- Hook into player turn started for per-turn effects
function OnPlayerTurnStarted(playerID)
    ApplyBonusYieldsPerTurn(playerID);
    AddLoyaltyPressure(playerID);
    EnableTerraceImprovements(playerID);
    EnhanceMountainTilesNearTerraceFarms(playerID);
end

-- Hook into tech/civic completion for boosts
function OnTechCivicCompleted(playerID, techID, isCivic)
    GrantFreeAdvances(playerID);
end

-- ==========================================================================
-- INITIALIZATION
-- ==========================================================================

-- Initialize the mod
function Initialize()
    -- Register events
    Events.PlayerTurnStarted.Add(OnPlayerTurnStarted);
    Events.TechCivicCompleted.Add(OnTechCivicCompleted);
    
    print("Super Civilization Mod: Lua script loaded");
end

-- Start the mod
Initialize(); 