QBAR = {}
QBAR.name = "qbar"
QBAR.version = "1.0.0"
QBAR.timeline = nil

local N_SLOTS = 8
local EMPTY_SLOT_SOUND = "Ability_WrongWeapon"
local EASING_FUNCTION = ZO_EaseInQuintic
local FADE_OUT_DURATION = 3500
local SLOT_MAP = {12, -- NORTH
		  11, -- NORTH-EAST
		  10, -- EAST
		  9,  -- SOUTH-EAST
		  16, -- SOUTH
		  15, -- SOUTH-WEST
		  14, -- WEST
		  13, -- NORTH-WEST
}
local timeline = nil

local function targetChanged()
   if timeline ~= nil and timeline:IsPlaying() then
      name = GetUnitName("reticleover")
      reaction = GetUnitReaction("reticleover")
      hostile = name ~="" and reaction == UNIT_REACTION_HOSTILE
      
      if hostile then
	 timeline:Stop()
	 ZO_ActionBar1:SetAlpha(1)
      end
   end
end

local function init(eventCode, addOnName)
   if (addOnName == QBAR.name) then
      for i=1, N_SLOTS do
	 ZO_CreateStringId("SI_BINDING_NAME_QBAR_SLOT_"..i,
			   "Select Quickbar Slot "..i)
      end
   end
   EVENT_MANAGER:RegisterForEvent(QBAR.name, EVENT_RETICLE_TARGET_CHANGED, targetChanged)
end

local function initAnimation()
   timeline = ANIMATION_MANAGER:CreateTimeline()
   timeline:SetPlaybackType(0, 0)
   animation = timeline:InsertAnimation(ANIMATION_ALPHA, ZO_ActionBar1, 0)
   animation:SetDuration(FADE_OUT_DURATION)
   animation:SetAlphaValues(1, 0)
   animation:SetEasingFunction(EASE_FUNCTION)

end

local function showActionBar()

   if timeline == nil then
      initAnimation()
   end
   
   if ZO_ActionBar1:IsHidden() then
      ZO_ActionBar1:ToggleHidden()
   end

   if ZO_ActionBar1:GetAlpha() == 0 or timeline:IsPlaying() then
      timeline:PlayFromStart()
   end
end

function QBAR.SlotKeyDown(n)
   slot = SLOT_MAP[n]
     
   if GetSlotItemCount(slot) == 0 then
      -- empty slot or out of stacked item
      PlaySound(EMPTY_SLOT_SOUND)
   else
      SetCurrentQuickslot(slot)
      itemSoundCategory = GetSlotItemSound(slot)
      PlayItemSound(itemSoundCategory, 1)
      if not IsUnitInCombat("player") then
	 showActionBar()
      end
   end
end

EVENT_MANAGER:RegisterForEvent(QBAR.name, EVENT_ADD_ON_LOADED, init)

