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
-- EVENT HANDLERS
-- ==========================================================================

-- Hook into player turn started for per-turn effects
function OnPlayerTurnStarted(playerID)
    ApplyBonusYieldsPerTurn(playerID);
    AddLoyaltyPressure(playerID);
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