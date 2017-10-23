require 'core/appkit/lua/class'
require 'core/appkit/lua/app'
local SimpleProject = require 'core/appkit/lua/simple_project'
local ComponentManager = require 'core/appkit/lua/component_manager'
local UnitController = require 'core/appkit/lua/unit_controller'
local UnitLink = require 'core/appkit/lua/unit_link'
local CameraWrapper = require 'core/appkit/lua/camera_wrapper'
local PlayerHud = require 'script/lua/player_hud'
local Util = require 'core/appkit/lua/util'


Project.SoundManager = Appkit.class(Project.SoundManager)
local SoundManager = Project.SoundManager -- cache off for readability and speed

function SoundManager.play_spawn_sound()
	if stingray.Wwise then
		stingray.Wwise.load_bank("content/audio/default") -- temporarily necessary for autoload mode to work
		local wwise_world = stingray.Wwise.wwise_world(SimpleProject.world)
		stingray.WwiseWorld.trigger_event(wwise_world, "sfx_spawn_sound")
	end
end

function SoundManager.play_Game_Music()
	if stingray.Wwise then
		stingray.Wwise.load_bank("content/audio/default") -- temporarily necessary for autoload mode to work
		local wwise_world = stingray.Wwise.wwise_world(SimpleProject.world)
		stingray.WwiseWorld.trigger_event(wwise_world, "Play_Music001")
	end
end

function SoundManager.Block_Spawn_Sound(blockIndex)

    if blockIndex == 1 then

    elseif blockIndex == 2 then

    elseif blockIndex == 3 then

    elseif blockIndex == 4 then

    elseif blockIndex == 5 then

    elseif blockIndex == 6 then

    elseif blockIndex == 7 then

    else

    end


end


return SoundManager