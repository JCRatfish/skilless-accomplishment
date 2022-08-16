local AddonName, AddonTable = ...

-- Check addon folder name and require LibStub
AddonTable.AddonName = "SkillessAccomplishment"
if (AddonName ~= AddonTable.AddonName) or (not LibStub) then
  return
end

AddonTable.GetMaximumLevel = function()
  if GetAccountExpansionLevel() > 0 then
    return GetMaxLevelForPlayerExpansion() -- retail only
  else
    return GetMaxPlayerLevel() -- classic versions
  end
end

AddonTable.Ace3 = {
  Addon = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0"),
  Database = {
    Name = AddonName .."DB",
    Defaults = {
      global = {
        freq = 1
      }
    }
  },
  Options = {
    type = "group",
    args = {
      freq = {
        name = "Frequency",
        desc = "How frequently you want the soundbite to play (accepts 1-".. AddonTable.GetMaximumLevel() ..").",
        type = "range",
        set = function(info,frequency)
          frequency = math.floor(frequency) -- no floats allowed
    		  if frequency < 1 then -- no negatives allowed
    		    frequency = 1
  	      elseif frequency > AddonTable.GetMaximumLevel() then -- no big-ass numbers allowed
		        frequency = AddonTable.GetMaximumLevel()
    		  end
    		  AddonTable.Ace3.Addon.Database.global.freq = frequency
          AddonTable.Ace3.Addon.PrintNotification()
		    end,
        get = function(info) return AddonTable.Ace3.Addon.Database.global.freq end
      }
    }
  }
}

function AddonTable.Ace3.Addon:OnInitialize()
  LibStub("AceConfig-3.0"):RegisterOptionsTable(AddonName, AddonTable.Ace3.Options, {"sa"})
  self.Database = LibStub("AceDB-3.0"):New(AddonTable.Ace3.Database.Name, AddonTable.Ace3.Database.Defaults)
end

function AddonTable.Ace3.Addon.PrintNotification()
  local notification = "Asmongold will congratulate you every "
  if AddonTable.Ace3.Addon.Database.global.freq == 1 then
    notification = notification .."level."
  elseif AddonTable.Ace3.Addon.Database.global.freq > AddonTable.GetMaximumLevel()/2 then
    notification = notification:gsub("every ", "at level ".. AddonTable.Ace3.Addon.Database.global.freq ..".")
  else
    notification = notification .. AddonTable.Ace3.Addon.Database.global.freq .." levels."
  end
  AddonTable.Ace3.Addon:Print(notification)
end
