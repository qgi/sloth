SLOTH = {}
SLOTH.name = "sloth"
SLOTH.version = "1.1"
SLOTH.timeline = nil

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
   if addOnName == SLOTH.name then
      for i=1, N_SLOTS do
	 ZO_CreateStringId("SI_BINDING_NAME_SLOTH_SLOT_"..i,
			   "Quickslot "..i)
      end
      ZO_CreateStringId("SI_BINDING_NAME_SLOTH_PREVIOUS_SLOT", "Previous Quickslot")
      ZO_CreateStringId("SI_BINDING_NAME_SLOTH_NEXT_SLOT", "Next Quickslot")
      EVENT_MANAGER:RegisterForEvent(SLOTH.name, EVENT_RETICLE_TARGET_CHANGED, targetChanged)
   end
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

   -- ActionBar is already visible
   -- in combat
   if IsUnitInCombat("player") then
      return
   end

   if timeline == nil then
      initAnimation()
   end

   if ZO_ActionBar1:IsHidden() then
      ZO_ActionBar1:ToggleHidden()
   end

   -- ActionBar hidden or fading out
   if ZO_ActionBar1:GetAlpha() == 0 or timeline:IsPlaying() then
      timeline:PlayFromStart()
   end
end

local function slotEmpty(slot)
   return GetSlotItemCount(slot) == 0
end

local function setSlot(slot)
   SetCurrentQuickslot(slot)
   sound = GetSlotItemSound(slot)
   PlayItemSound(sound, 1)
   showActionBar()
end

function SLOTH.SlotKeyDown(n)
   if not IsGameCameraUIModeActive() then
      slot = SLOT_MAP[n]
      if slotEmpty(slot) then
	 PlaySound(EMPTY_SLOT_SOUND)
      else
	 setSlot(slot)
      end
   end
end

function switchSlot(increment)

   oldSlot = GetCurrentQuickslot()
   slot = oldSlot

   repeat
      slot = slot + increment
      if slot < 9 then
	 slot = slot + 8
      elseif slot > 16 then
	 slot = slot - 8
      end

      if not slotEmpty(slot) then
	 setSlot(slot)
	 return
      end
   until slot == oldSlot

   PlaySound(EMPTY_SLOT_SOUND)
end

function SLOTH.NextSlotKeyDown()
   if not IsGameCameraUIModeActive() then
      switchSlot(-1)
  end
end

function SLOTH.PreviousSlotKeyDown()
   if not IsGameCameraUIModeActive() then
      switchSlot(1)
   end
end

EVENT_MANAGER:RegisterForEvent(SLOTH.name, EVENT_ADD_ON_LOADED, init)
