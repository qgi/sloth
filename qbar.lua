local N_SLOTS = 8
local DURATION = 250
local texture = ""
local timeline = nil
local EMPTY_SLOT_SOUND = "Ability_WrongWeapon"

QBAR = {}

for i=1, N_SLOTS do
   ZO_CreateStringId("SI_BINDING_NAME_QBAR_SLOT_"..i,
		     "Quickbar Slot "..i)
end

local function getSlot(n)
   if n<5 then
      return 13-n
   else
      return 21-n
   end
end

local function useItemAtSlot(slot)
   for bagId=1, GetMaxBags() do
      _, nSlots = GetBagInfo(bagId)
      for slotIndex=1, nSlots do
	 if GetItemCurrentActionBarSlot(bagId, slotIndex) == slot then
	    d(GetItemName(bagId, slotIndex))
	    CallSecureProtected("UseItem", bagId, slotndex)
	    return
	 end
      end
   end
end

local function animate()
   if not timeline then
      timeline = ANIMATION_MANAGER:CreateTimeline()
      timeline:SetPlaybackType(0, 0)
      animation = timeline:InsertAnimation(ANIMATION_ALPHA, QBARTexture, 0)
      animation:SetDuration(DURATION)
      animation:SetAlphaValues(0, 1)
      animation:SetEasingFunction(ZO_LinearEase)
   end
   timeline:PlayFromStart()
   timeline:PlayFromEnd()
end

function QBAR.SlotKeyDown(n)
   slot = getSlot(n)
   if GetSlotBoundId(slot) == 0 or GetSlotItemCount(slot) == 0 then
      PlaySound(EMPTY_SLOT_SOUND)
   else
      SetCurrentQuickslot(slot)
      itemSoundCategory = GetSlotItemSound(slot)
      PlayItemSound(itemSoundCategory, 1)
      texture, _, _ = GetSlotTexture(slot)
      QBARTexture:SetTexture(texture)
      animate()
   end
end

function QBAR.Update()
end



