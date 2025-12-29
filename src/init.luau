--[[
    Created and maintained by baj
    Reactive Tags v2
    https://github.com/bajsucks/ReactiveTags
    https://github.com/bajsucks/ReactiveSubmodules
    Submodules should be parented to SUBMODULE_PATH on line 38 (default is ReplicatedStorage/ReactiveSubmodules)
    All submodules must have a module.Tags table with tag relations to automatically load. It looks like this:
    module.Tags = {["Tag"] = module.Resolver}
    module.Resolver will be given an instance to process as an argument.
    


    $$$$$$$\                                  $$\     $$\                      
    $$  __$$\                                 $$ |    \__|                     
    $$ |  $$ | $$$$$$\   $$$$$$\   $$$$$$$\ $$$$$$\   $$\ $$\    $$\  $$$$$$\  
    $$$$$$$  |$$  __$$\  \____$$\ $$  _____|\_$$  _|  $$ |\$$\  $$  |$$  __$$\ 
    $$  __$$< $$$$$$$$ | $$$$$$$ |$$ /        $$ |    $$ | \$$\$$  / $$$$$$$$ |
    $$ |  $$ |$$   ____|$$  __$$ |$$ |        $$ |$$\ $$ |  \$$$  /  $$   ____|
    $$ |  $$ |\$$$$$$$\ \$$$$$$$ |\$$$$$$$\   \$$$$  |$$ |   \$  /   \$$$$$$$\ 
    \__|  \__| \_______| \_______| \_______|   \____/ \__|    \_/     \_______|
                                                                               
                                                                               
    $$$$$$$$\                                                                  
    \__$$  __|                                                                 
       $$ | $$$$$$\   $$$$$$\   $$$$$$$\                                       
       $$ | \____$$\ $$  __$$\ $$  _____|                                      
       $$ | $$$$$$$ |$$ /  $$ |\$$$$$$\                                        
       $$ |$$  __$$ |$$ |  $$ | \____$$\                                       
       $$ |\$$$$$$$ |\$$$$$$$ |$$$$$$$  |                                      
       \__| \_______| \____$$ |\_______/                                       
                     $$\   $$ |                                                
                     \$$$$$$  |                                                
                      \______/                                                 
]]

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SUBMODULE_PATH = ReplicatedStorage:FindFirstChild("ReactiveSubmodules") -- <-- change this!

local ReactiveTags = {}
local Initialized = false

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
    Autodefines submodules and boots up the tag resolver
]]
function ReactiveTags.init()
    if SUBMODULE_PATH then
        for _, Sub in SUBMODULE_PATH:GetChildren() do
            local Relations = Sub.Tags
            if not Relations then continue end
            for Tag, Func in Relations do
                ReactiveTags.Define(Tag, Func)
            end
        end
    end
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
    Defines a new tag relation. Keep in mind that tags can only be defined BEFORE .init() or AUTOMATICALLY using the submodule folder.
    You can also override already existing reactive tags using this function.
]]
function ReactiveTags.Define(Tag:string, Func:(ins:Instance)->())
    if Initialized then
        warn("Cannot add a reactive tag when ReactiveTags is already initialized!")
    end
    TagRegister[Tag] = Func
end

-- just gets the register lol idk why'd you need this
function ReactiveTags.GetTagRegister()
    return TagRegister
end

return ReactiveTags