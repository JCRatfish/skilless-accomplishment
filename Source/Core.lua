local AddonName, AddonTable = ...
if not AddonTable.Ace3.Addon then
  return
end

local SkillessAccomplishment = AddonTable.Ace3.Addon

function SkillessAccomplishment:OnEnable()
  AddonTable.Ace3.Addon.PrintNotification()
  self:RegisterEvent("PLAYER_LEVEL_UP", self.PLAYER_LEVEL_UP)
end

function SkillessAccomplishment.PLAYER_LEVEL_UP(event, ...)
  local level, healthDelta, powerDelta, numNewTalents, numNewPvpTalentSlots, strengthDelta, agilityDelta, staminaDelta, intellectDelta = ...
  if mod(level, SkillessAccomplishment.Database.global.freq) == 0 then
    C_Timer.After(3, function()
      local willPlay, soundHandle = PlaySoundFile("Interface\\AddOns\\".. AddonName .."\\Media\\SkillessAccomplishment.ogg", "Dialog")
    end)
  end
end
