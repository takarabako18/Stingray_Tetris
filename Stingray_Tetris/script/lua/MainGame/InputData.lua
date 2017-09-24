Project.InputData = Appkit.class(Project.InputData)
local InputData = Project.InputData -- cache off for readability and speed

--左右入力ため時間
local tameFrame = 7

--回転 
pressCircle =false
function InputData.pressCircle () return pressCircle end
pressCross =false
function InputData.pressCross () return pressCross end

--IRSのしすてむ
pressingCircle =false
function InputData.pressingCircle () return pressingCircle end
pressingCross =false
function InputData.pressingCross () return pressingCross end


-- ホールド
pressSquare =false
function InputData.pressSquare () return pressSquare end
--IHSのシステム
pressingSquare =false
function InputData.pressingSquare () return pressingSquare end

-- 落下中のボタン制御

-- 方向入力

--下
pressedDown = false
function InputData.pressedDown () return pressedDown end

pressedUp =false
function InputData.pressedUp () return pressedUp end

--左
pressLeft = false
function InputData.pressLeft () return pressLeft end
pressingLeft = false
function InputData.pressingLeft () return pressingLeft end
local pressedLeft = false
local pressingLeftCount = 0


--右
pressRight = false
function InputData.pressRight () return pressRight end
pressingRight = false
function InputData.pressingRight () return pressingRight end
local pressedRight = false
local pressingRightCount = 0




local function updateButtonCheck()

    
    -- triangle、circle、cross、square
    --l1 と r1
    -- up、right、down、left
    
    --初期化
    --print("updateButtonCheck")
    
    local circle = stingray.PS4Pad1.button_id("circle")
    local cross = stingray.PS4Pad1.button_id("cross")
    local square = stingray.PS4Pad1.button_id("square")

    --丸ボタン
    pressCircle = false
    if stingray.PS4Pad1.pressed(circle) then
        pressCircle = true
        pressingCircle = true
    elseif stingray.PS4Pad1.released(circle) then
    	pressingCircle = false
    end

    -- 罰ボタン
    pressCross = false
    if stingray.PS4Pad1.pressed(cross) then
        pressCross = true
        pressingCross = true
    elseif stingray.PS4Pad1.released(cross) then
    	pressingCross = false
    end


    -- 四角ボタン
    pressSquare = false
    if stingray.PS4Pad1.pressed(square) then
        pressSquare = true
        pressingSquare = true
    elseif stingray.PS4Pad1.released(square) then
    	pressingSquare = false
    end
    
    
    -- local l1 = stingray.PS4Pad1.button_id("l1")
    -- local r1 = stingray.PS4Pad1.button_id("r1")
    
    -- 上入力
    local up = stingray.PS4Pad1.button_id("up")
    pressedUp = false
    if stingray.PS4Pad1.pressed(up) then
        pressedUp = true
    end
    
    --下入力
    local down = stingray.PS4Pad1.button_id("down")
    if stingray.PS4Pad1.pressed(down) then
        pressedDown = true
    end
    if stingray.PS4Pad1.released(down) then
        pressedDown = false
    end
    
    
    --左入力
    pressLeft = false
    local left = stingray.PS4Pad1.button_id("left")
    if stingray.PS4Pad1.pressed(left) then
        pressedLeft = true
        pressLeft = true
    elseif stingray.PS4Pad1.released(left) then
        pressedLeft = false
    end
    --左入力おしっぱ
    if pressedLeft then
        pressingLeftCount = pressingLeftCount + 1
        if pressingLeftCount > tameFrame then
            pressingLeft = true
        end
    else
        pressingLeft = false
        pressingLeftCount = 0
    end
    
    
    
    --右入力
    pressRight = false
    local right = stingray.PS4Pad1.button_id("right")
    if stingray.PS4Pad1.pressed(right) then
        pressedRight = true
        pressRight = true
    elseif stingray.PS4Pad1.released(right) then
        pressedRight = false
    end
    --右入力おしっぱ
    if pressedRight then
        pressingRightCount = pressingRightCount + 1
        if pressingRightCount > tameFrame then
            pressingRight = true
        end
    else
        pressingRight = false
        pressingRightCount = 0
    end
end



function InputData.Start(level)

	stingray.Application.scan_for_windows_ps4_controllers()

	-- local inputData = InputData()
	-- --Updateとかを登録
 --    Appkit.manage_level_object(level, InputData, inputData)
    
end


function InputData.update(self, dt)
	--ボタンの状態をしゅとくする
	updateButtonCheck()
	
end

-- function InputData.shutdown(self, level)
--     -- ゲーム終了時
--     --中身がなくてもmanage_level_objectしたら関数が必要っぽい
--     --なければシャットダウン時えらーになる
    
-- end

return InputData
