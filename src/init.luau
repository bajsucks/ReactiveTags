local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local ReactiveTags = {}
local Initialized = false
local CompoundRegister = {}
local DefaultRegister = {}
local ComTypes = {
    ["Position"] = 1,
    ["Size"] = 2,
    ["Rotation"] = 3,
    ["Color"] = 4
}
-- Addd a compound
local function Compound(Obj:Instance, Tag:string, Comtype:string, Value:any)
    CompoundRegister[Obj] = CompoundRegister[Obj] or {}
	CompoundRegister[Obj][Tag] = CompoundRegister[Obj][Tag] or {}
	CompoundRegister[Obj][Tag][Comtype] = Value
end

local function GetCompoundValues(Obj)
	
end

-- Clear 1 tag compound of 1 object
local function ClearCompound(Obj:Instance, Tag:string)
	local reg = CompoundRegister[Obj]
	if not reg then return end
	reg[Tag] = nil
end
-- Completely erase an object from all registers
local function Superclear(Obj:Instance)
	CompoundRegister[Obj] = nil
	DefaultRegister[Obj] = nil
end

local TagRegister = {
    ["Shakey"] = function(v:Instance)
        local function e(m)
            warn("Could not apply Shakey to instance", v, ":", m)
        end
        if v:HasTag("HoverShakey") then
            e("Can only have 1 Shakey tag on an instance at once!")
            return
        end
        local x = v:GetAttribute("ShakeyX")
        local y = v:GetAttribute("ShakeyY")
        local rot = v:GetAttribute("ShakeyRot")
        -- default values are funky because all of those use the same sinus, so if speeds don't differ, they'll sync which is bad
        local speedx = v:GetAttribute("ShakeySpeedX") or 0.9
        local speedy = v:GetAttribute("ShakeySpeedY") or 1.05
        local speedrot = v:GetAttribute("ShakeySpeedRot") or 0.98
        if not x and not y and not rot then
            e("Tried to start Shakey without arguments!")
            return
        end
        x = x or 0
        y = y or 0
        rot = rot or 0
        local totaldt = 0
        local OrigPosition = v.Position
        local OrigRotation = v.Rotation
        local c = RunService.RenderStepped:Connect(function(dt)
            totaldt += dt
            CompoundRegister[v] = CompoundRegister[v] or {}
            v.Position = OrigPosition + UDim2.fromScale(math.sin(totaldt*speedx), math.sin(totaldt*speedy))
            v.Rotation = OrigRotation + math.sin(totaldt*speedrot)*rot - rot/2
        end)
        v.Destroying:Once(function()
            c:Disconnect()
        end)
    end
}

-- temporary documentation:
--[[

Shakey:
    Change size using cos and sin always (smooth shaking fx)

HoverShakey:
    Change size using cos and sin while hovering (smooth shaking fx)

Hover:
    change size andor color on Hover

ClickBegin:
    change size andor color on Click

ClickEnded:
    change size andor color on Click Ended
    
]]

-- Calls ALL tags for an object
local function HandleTags(obj:Instance)
    for i, v in TagRegister do
        if obj:HasTag(i) then
            v(obj)
        end
    end
end

-- boots up the tag resolver
function ReactiveTags.init()
    for _, v in CollectionService:GetTagged("Reactive") do
        HandleTags(v)
    end
    for i, v in TagRegister do
        CollectionService:GetInstanceAddedSignal(i):Connect(function(obj:Instance)
            v(obj)
        end)
    end
    Initialized = true
end
--[[
    Defines a new tag in jTail. Keep in mind that tags can only be defined BEFORE .init()
    You can also overwrite already existing jTail tags using this function.
]]
function ReactiveTags.Define(Tag:string, Func:(ins:Instance)->())
    if Initialized then
        warn("Cannot add a jTail tag when jTail is already initialized!")
    end
    TagRegister[Tag] = Func
end

-- just gets the register lol idk why'd you need this
function ReactiveTags.GetTagRegister()
    return TagRegister
end

return ReactiveTags