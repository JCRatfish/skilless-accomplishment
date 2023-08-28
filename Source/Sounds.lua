local AddonName, AddonTable = ...  

if not AddonTable.Ace3.Addon then return end

local sounds = { 
  Overconfidence = "Overconfidence.mp3", 
  SkillessAccomplishment = "SkillessAccomplishment.ogg", 
} 

function SetSounds()
    AddonTable.Ace3.Config.Options.args.sound.values = sounds
end

SetSounds()