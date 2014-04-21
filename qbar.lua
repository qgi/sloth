local N_SLOTS = 8
local EMPTY_SLOT_SOUND = "Ability_WrongWeapon"

QBAR = {}

for i=1, N_SLOTS do
   ZO_CreateStringId("SI_BINDING_NAME_QBAR_SLOT_"..i,
		     "Select Quickbar Slot "..i)
end

local function getSlot(n)
   if n<5 then
      return 13-n
   else
      return 21-n
   end
end

function QBAR.SlotKeyDown(n)
   slot = getSlot(n)
   if GetSlotBoundId(slot) == 0 or GetSlotItemCount(slot) == 0 then
      PlaySound(EMPTY_SLOT_SOUND)
   else
      SetCurrentQuickslot(slot)
      itemSoundCategory = GetSlotItemSound(slot)
      PlayItemSound(itemSoundCategory, 1)
      if ZO_ActionBar1:IsHidden() then
	 ZO_ActionBar1:ToggleHidden()
      end
      if ZO_ActionBar1:GetAlpha() == 0 then
	 ZO_ActionBar1:SetAlpha(1)
	 -- TODO: Should fade out after some time
      end
   end
end


