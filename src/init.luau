local CollectionService = game:GetService("CollectionService")
local StarterGui = game:GetService("StarterGui")
local ReactiveTags = {}
local Initialized = false
local CompoundRegister = {}
local DefaultRegister = {}

--[[
    Add a new compound
    @param Property Property which will be affected 
    @param Value Value that will be compounded. Note that the next time you call Compound() it will overwrite it.
]]
local function Compound(Obj:Instance, Tag:string, Property:string, Value:any)
    CompoundRegister[Obj] = CompoundRegister[Obj] or {}
	CompoundRegister[Obj][Tag] = CompoundRegister[Obj][Tag] or {}
	CompoundRegister[Obj][Tag][Property] = Value
end

--[[
    Returns all compounded properties and their values of an object.
]]
local function GetCompoundValues(Obj)
    local tags = CompoundRegister[Obj]
    if not tags then return {} end
    local Values = {}
    local function add(prop, val)
        if Values[prop] then
            Values[prop] = Values[prop] + val
        else
            Values[prop] = val
        end
    end
	for _, properties in tags do
        for prop, val in properties do
            add(prop, val)
        end
	end
    return Values
end

--[[
    Clear 1 tag compound of 1 object
]]
local function ClearCompound(Obj:Instance, Tag:string)
	local reg = CompoundRegister[Obj]
	if not reg then return end
	reg[Tag] = nil
end
--[[
    Completely erase an object from all registers
]]
local function Superclear(Obj:Instance)
	CompoundRegister[Obj] = nil
	DefaultRegister[Obj] = nil
end

local TagRegister = {}

--[[
    Calls ALL tags for an object
]]
local function HandleTags(obj:Instance)
    for i, v in TagRegister do
        if obj:HasTag(i) then
            v(obj)
        end
    end
end

--[[
    boots up the tag resolver
]]
function ReactiveTags.init()
    for _, v in CollectionService:GetTagged("Reactive") do
        if v:IsDescendantOf(StarterGui) then continue end
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