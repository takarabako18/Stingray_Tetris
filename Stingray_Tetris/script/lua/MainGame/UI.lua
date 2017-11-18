local Util = require 'core/appkit/lua/util'
local SimpleProject= require 'core/appkit/lua/simple_project'
Project.MainGameUI = Project.MainGameUI or {}
local MainGameUI = Project.MainGameUI

local Vector3 = stingray.Vector3
local Vector3Box = stingray.Vector3Box
local Keyboard = stingray.Keyboard

local ui_level = nil

local function str(x)
	return x .. ""
end

if scaleform == nil then 
	PlayerHud = { init = function() end,
				  update   = function() end,
				  shutdown = function() end,
				  exit_level = function() end,
				}
	return PlayerHud
end


-- UI側からのイベントの受け口
---- scaleform.EventListener.connect で登録しないと呼ばれない
function MainGameUI:on_custom_event(evt)


	print(evt.name)
	if evt.name == "Button_clicked" then
		stingray.Application.quit()
	end
end

function MainGameUI:aaa()

    scaleform.Stingray.send_message("mouse_move" ,
    stingray.Mouse.axis(stingray.Mouse.axis_index("cursor"), stingray.Mouse.RAW, 3).x,
    stingray.Mouse.axis(stingray.Mouse.axis_index("cursor"), stingray.Mouse.RAW, 3).y)


end


-- ブロックスポーン時
function MainGameUI.updateLevelData(level)
	local event = {
		eventId = scaleform.EventTypes.Custom,
		name = nil,
		data = nil
	}

	event.name = "updateLevel"
	-- 文字列変換は演算子　.."" で可能
	-- 結合は　a..a
	local s = str(level)
	s = "Level : "..s
	event.data = s
	-- event.data = levelData.level


	-- print("update_pc_hud")

	scaleform.Stage.dispatch_event(event)

	-- scaleform.Stingray.send_message("aaaa" , "aaS")

	-- scaleform.Stingray.send_message("mouse_move" ,
    -- stingray.Mouse.axis(stingray.Mouse.axis_index("cursor"), stingray.Mouse.RAW, 3).x,
	-- stingray.Mouse.axis(stingray.Mouse.axis_index("cursor"), stingray.Mouse.RAW, 3).y)
	


	-- print("update_pc_hud2")

end

--ライン削除時
function MainGameUI.updateDeleteData(levelData, deleteLine)

	local event = {
		eventId = scaleform.EventTypes.Custom,
		name = nil,
		data = nil
	}
	event.name = "updateLevel"
	local s = str(levelData)
	s = "Level : "..s
	event.data = s
	scaleform.Stage.dispatch_event(event)


	local event2 = {
		eventId = scaleform.EventTypes.Custom,
		name = nil,
		data = nil
	}

	event2.name = "updateDeleteLine"
	local s2 = str(deleteLine)
	s2 = "Line : "..s2
	event2.data = s2
	scaleform.Stage.dispatch_event(event2)

end




function MainGameUI:init()
	--Used for mobile hud controls but it simplifies the logic in player if they're always available.
	-- self.input = {
	-- 	pan = Vector3Box(Vector3(0, 0, 0)),
	-- 	move = Vector3Box(Vector3(0, 0, 0)),
	-- 	jump = false,
	-- 	toggle_camera = false,
	-- 	sprint = false,
	-- 	exit_level = false
    -- }
    -- UIのプロジェクトを読み込む
    local current_level = SimpleProject.level
	-- scaleform.Stingray.load_project_and_scene("content/ui/main_game.s2d/main_game");
	scaleform.Stingray.load_project_and_scene("content/ui/template_hud.s2d/template_hud");
	ui_level = current_level
	
	-- 読み込んだUIに対してUI側からのイベントを受け入れる口を登録する
	-- -- 例えば、ボタンとか
	-- local custom_listener = MainGameUI.custom_listener
	-- custom_listener = scaleform.EventListener.create(custom_listener, function (e) MainGameUI.on_custom_event(MainGameUI,e) end)
	-- MainGameUI.custom_listener = custom_listener
	-- scaleform.EventListener.connect(custom_listener, scaleform.EventTypes.Custom2)
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