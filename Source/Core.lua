local AddonName, AddonTable = ...

if not AddonTable.Ace3.Addon then return end

function AddonTable.Ace3.Addon:OnInitialize()
  self.Database = LibStub("AceDB-3.0"):New(AddonTable.Ace3.Database.Name, AddonTable.Ace3.Database.Defaults)
  LibStub("AceConfig-3.0"):RegisterOptionsTable(AddonName, AddonTable.Ace3.Config.Options, {"sa"})
end

function AddonTable.Ace3.Addon:OnEnable()
  if AddonTable.Ace3.Addon.Database.global.notify then
    AddonTable.Functions.PrintNotification()
  end
  -- register level up event
  self:RegisterEvent("PLAYER_LEVEL_UP", function(event, level)
    if mod(level, AddonTable.Ace3.Addon.Database.global.freq) == 0 then
      -- level is divisible by frequency with no remainder
      C_Timer.After(4, function()
        -- wait a moment before playing the soundbite
        PlaySoundFile("Interface\\AddOns\\".. AddonName .."\\Media\\".. sound, AddonTable.Ace3.Addon.Database.global.channel)
      end)
    end
  end)
end
