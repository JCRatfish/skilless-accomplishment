local AddonName, AddonTable = ...
local AddonNameVerification = "SkillessAccomplishment"

if (AddonName ~= AddonNameVerification) or (not LibStub) then return end

AddonTable.Functions = {
  GetMaximumPlayerLevel = function()
    if GetAccountExpansionLevel() > 0 then
      return GetMaxLevelForPlayerExpansion() -- retail
    else
      return GetMaxPlayerLevel() -- classic
    end
  end,
  PrintNotification = function()
    local notification = "Remind yourself to stay humble "
    if AddonTable.Ace3.Addon.Database.global.freq == 1 then
      notification = notification .. AddonTable.Functions.WrapTextWithColor("every") .." level."
    elseif AddonTable.Ace3.Addon.Database.global.freq > AddonTable.Functions.GetMaximumPlayerLevel()/2 then
      notification = notification .."at level ".. AddonTable.Functions.WrapTextWithColor(AddonTable.Ace3.Addon.Database.global.freq) .."."
    else
      notification = notification .."every ".. AddonTable.Functions.WrapTextWithColor(AddonTable.Ace3.Addon.Database.global.freq) .." levels."
    end
    AddonTable.Ace3.Addon:Print(notification)
  end,
  WrapTextWithColor = function(text)
    local colorHexString = "ffffff78" -- Ace3 argument color
    return WrapTextInColorCode(text, colorHexString)
  end
}

AddonTable.Ace3 = {
  Addon = LibStub("AceAddon-3.0"):NewAddon(AddonName, "AceConsole-3.0", "AceEvent-3.0"),
  Database = {
    Name = AddonName .."DB",
    Defaults = {
      global = {
        sound = "SkillessAccomplishment.ogg",
        freq = 10,
        channel = "Dialog",
        notify = true
      }
    }
  },
  Config = {
    Options = {
      type = "group",
      args = {
        sound = {
          name = "Sound",
          desc = "Select which sound you would like to play.",
          type = "select",
          get = function(info) return AddonTable.Ace3.Addon.Database.global.sound end,
          set = function(info,sound)
            AddonTable.Ace3.Addon:Print(AddonTable.Functions.WrapTextWithColor(sound) ..' selected for playback. Now playing file...')
            AddonTable.Ace3.Addon.Database.global.sound = sound
            PlaySoundFile("Interface\\AddOns\\".. AddonName .."\\Media\\".. AddonTable.Ace3.Addon.Database.global.sound, AddonTable.Ace3.Addon.Database.global.channel)
          end,
          values = SoundList
        },
        freq = {
          name = "Frequency",
          desc = "How frequently you want the soundbite to play (accepts 1-".. AddonTable.Functions.GetMaximumPlayerLevel() ..").",
          type = "range",
          get = function(info) return AddonTable.Ace3.Addon.Database.global.freq end,
          set = function(info,frequency)
            frequency = math.floor(frequency) -- no floats allowed
      		  if frequency < 1 then -- no negatives allowed
      		    frequency = 1
    	      elseif frequency > AddonTable.Functions.GetMaximumPlayerLevel() then -- no big-ass numbers allowed
  		        frequency = AddonTable.Functions.GetMaximumPlayerLevel()
      		  end
      		  AddonTable.Ace3.Addon.Database.global.freq = frequency
            AddonTable.Functions.PrintNotification()
  		    end
        },
        channel = {
          name = "Channel",
          desc = 'Audio channel used for playing the soundbite (default: Dialog).',
          type = "select",
          get = function(info) return AddonTable.Ace3.Addon.Database.global.channel end,
          set = function(info,value)
            AddonTable.Ace3.Addon:Print(AddonTable.Functions.WrapTextWithColor(value) ..' audio channel selected for playback.')
            if value == "Sound" then
              value = "SFX"
            end
            AddonTable.Ace3.Addon.Database.global.channel = value
          end,
          values = {
            Master = "Master",
            Sound = "Sound",
            Music = "Music",
            Ambience = "Ambience",
            Dialog = "Dialog"
          }
        },
        notify = {
          name = "Notify",
          desc = "Toggle the login message on/off.",
          type = "toggle",
          get = function(info) return AddonTable.Ace3.Addon.Database.global.notify end,
          set = function(info,notify)
            AddonTable.Ace3.Addon.Database.global.notify = notify
            local status = "enabled"
            if not notify then status = "disabled" end
            AddonTable.Ace3.Addon:Print("Login message ".. AddonTable.Functions.WrapTextWithColor(status) ..".")
          end
        }
      }
    }
  }
}
