local Util = require 'core/appkit/lua/util'
local SimpleProject= require 'core/appkit/lua/simple_project'
Project.MainGameUI = Project.MainGameUI or {}
local MainGameUI = Project.MainGameUI

local Vector3 = stingray.Vector3
local Vector3Box = stingray.Vector3Box
local Keyboard = stingray.Keyboard

local ui_level = nil

if scaleform == nil then 
	PlayerHud = { init = function() end,
				  update   = function() end,
				  shutdown = function() end,
				  exit_level = function() end,
				}
	return PlayerHud
end


function MainGameUI:on_custom_event(evt)

	-- if evt.name == "button_click" then
	-- 	if evt.data.action == "start_sprint" then
	-- 		self.input.sprint = true
	-- 		local move = Vector3(0, 1, 0)
	-- 		self.input.move:store(Vector3.normalize(move))
	-- 	end

	-- 	if evt.data.action == "stop_sprint" then
	-- 		local move = Vector3(0, 0, 0)
	-- 		self.input.move:store(Vector3.normalize(move))
	-- 		self.input.sprint = false
	-- 	end

	-- 	if evt.data.action == "toggle_camera" then
	-- 		self.input.toggle_camera = true
	-- 	end
	-- 	if evt.data.action == "return" then
	-- 		self.input.exit_level = true
	-- 	end
	-- end
end

function MainGameUI:init()
	--Used for mobile hud controls but it simplifies the logic in player if they're always available.
	self.input = {
		pan = Vector3Box(Vector3(0, 0, 0)),
		move = Vector3Box(Vector3(0, 0, 0)),
		jump = false,
		toggle_camera = false,
		sprint = false,
		exit_level = false
    }
    
    local current_level = SimpleProject.level
    scaleform.Stingray.load_project_and_scene("content/ui/main_game.s2d/main_game");
    ui_level = current_level
end


function MainGameUI:shutdown(level)
	if scaleform then
		scaleform.Stingray.unload_project();
		hud_level = nil
	end
end

function MainGameUI:exit_level()
	-- local ret = self.input.exit_level
	-- self.input.exit_level = false
	-- return ret
end

return MainGameUI