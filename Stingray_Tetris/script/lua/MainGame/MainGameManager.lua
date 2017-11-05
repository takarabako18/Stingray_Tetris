require "core/appkit/lua/class"
require "core/appkit/lua/app"

local Unit = stingray.Unit
local World = stingray.World
local Level = stingray.Level
local Vector3 = stingray.Vector3
local SimpleProject = require "core/appkit/lua/simple_project"

-- 固定された後のフィールド
local AreaLockModel = nil or {}
-- 落下中のブロックを含めた状態
local AreaModel = nil or {}
local AreaView = nil or {}

Project.MainGame = Appkit.class(Project.MainGame)
local MainGame = Project.MainGame -- cache off for readability and speed

local Enum = require "script/lua/LuaUtility/Enum"
local GameStateEnum = Enum:new {"Start", "Playing", "End", "Paused"}
local gameState = GameStateEnum.Playing
local PlayingStateEnum = Enum:new {"Falling", "Locked", "DeleteLine", "WaitNextPop"}
local playingState = PlayingStateEnum.Falling

local gameUI = require 'script/lua/MainGame/UI'

-- らっかちゅうブロック
local fallenBlock = {}

-- ボタンの入力情報
local input = {}

-- nextとほーるど
local NextAndHold = {}
-- レベルとか管理
local LevelManager = {}
-- 音管理
local SoundManager ={}

local emptyLine = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

------------------------------------------------------------------
-- ボタンの入力情報ここまで
------------------------------------------------------------------

-- Viewの更新（落下中のフレームの最後におこなう）
local function updateAreaView()
    -- AreaModel に AreaLockModel　のようなことをする
    for z, var1 in ipairs(AreaLockModel) do
        for x, var2 in ipairs(var1) do
            AreaModel[z][x] = var2
        end
    end

    if fallenBlock ~= nil then
        local shape = fallenBlock.block
        for z, var1 in ipairs(shape) do
            for x, var2 in ipairs(var1) do
                -- 0はこぴーしない
                if var2 > 0 then
                    local z2 = fallenBlock.z + z - 1
                    local x2 = fallenBlock.x + x - 1
                    if z2 > 20 or z2 < 1 then
                    elseif x > 10 or x < 1 then
                    else
                        if AreaModel[z2][x2] == 0 then
                            AreaModel[z2][x2] = var2
                        end
                    end
                end
            end
        end
    end

    --指定したｘ、ｚのぶろっくの描画を切り替える
    for z, var1 in ipairs(AreaModel) do
        for x, var2 in ipairs(var1) do
            local block = AreaView[z][x]
            if var2 > 0 then
                block.SetVisible(var2)
            else
                block.SetInvisible()
            end
        end
    end
end

local function tryDeleteLine()
    local deleted = false
    local lines = {}
    -- AreaModel に AreaLockModel　のようなことをする
    for z, var1 in ipairs(AreaLockModel) do
        d = true
        for x, var2 in ipairs(var1) do
            if var2 == 0 then
                d = false
            end
        end

        if d then
            deleted = true
            table.insert(lines, z)
        end
    end

    local lineCount = table.maxn(lines)
    for i = 1, lineCount do
        line = lines[lineCount - i + 1]
        table.remove(AreaLockModel, line)
    end
    for i = 1, lineCount do
        local l = {unpack(emptyLine)}
        table.insert(AreaLockModel, 1, l)
    end
    return deleted
end

--指定したブロックがう埋まっていないかチェックする
local function validDrawPoint(x, z)
    inArea = false
    if z < 21 and z > 0 then
        if x < 11 and x > 0 then
            inArea = true
        end
    end

    if inArea then
        local blockMOdel = AreaLockModel[z][x]
        if blockMOdel == 0 then
            return true
        else
            return false
        end
    else
        return false
    end
end

-- 通常のブロックを生成
local function spwanBlock()
    -- IHSをチェック、ホールドを行う
    if input.pressingSquare() then
        fallenBlock = NextAndHold.initalHold()
    else
        fallenBlock = NextAndHold.pop()
    end

    -- IRSをチェックして最初のブロック表示を算出
    if input.pressingCircle() then
        fallenBlock.rotateclockWise()
    elseif input.pressingCross() then
        fallenBlock.rotateReverse()
    end
    fallenBlock.setInitialPosition()



    local shape = fallenBlock.block
    for z, var1 in ipairs(shape) do
        for x, var2 in ipairs(var1) do
            local z2 = fallenBlock.z + z - 1
            local x2 = fallenBlock.x + x - 1
            if var2 ~= 0 then
                if validDrawPoint(x2, z2) then
                else
                    -- ここで失敗したら窒息
                    print("ちっそく")
                end
            end
        end
    end

    --こうかおん
    SoundManager.play_spawn_sound()


    -- 一回落下フレーム挟む
    updateAreaView()
end

local function changePlayingState(state)
    playingState = state
    if state == PlayingStateEnum.Falling then
        fallenBlock = nil
        --ブロックのぽっぷ
        spwanBlock()
    elseif state == PlayingStateEnum.Locked then
        fallenBlock = nil
        -- 落ちるブロックの破棄とライン削除判定
        for z, var1 in ipairs(AreaModel) do
            for x, var2 in ipairs(var1) do
                AreaLockModel[z][x] = var2
            end
        end

        local deleted = tryDeleteLine()
        if deleted then
            changePlayingState(PlayingStateEnum.DeleteLine)
        else
            changePlayingState(PlayingStateEnum.WaitNextPop)
        end

        LevelManager.setWaitFrame(deleted)
    elseif state == PlayingStateEnum.DeleteLine then
        --演出
    elseif state == PlayingStateEnum.WaitNextPop then
    -- 次のブロック落ちるまで待ち
    end
end

-- ブロックをホールドしたときの一連の流れ
local function holdBlockSpawn()
    fallenBlock = NextAndHold.hold(fallenBlock)

    -- IRSをチェックして最初のブロック表示を算出
    if input.pressingCircle() then
        fallenBlock.rotateclockWise()
    elseif input.pressingCross() then
        fallenBlock.rotateReverse()
    end
    fallenBlock.setInitialPosition()

    local shape = fallenBlock.block
    for z, var1 in ipairs(shape) do
        for x, var2 in ipairs(var1) do
            local z2 = fallenBlock.z + z - 1
            local x2 = fallenBlock.x + x - 1

            if var2 ~= 0 then
                if validDrawPoint(x2, z2) then
                else
                    -- ここで失敗したら窒息
                    print("ちっそく")
                end
            end
        end
    end
end

--引数分
local function tryRotationWithSuperRotation(xMove, zMove, b)
    local ratatable = true
    for z, var1 in ipairs(b) do
        for x, var2 in ipairs(var1) do
            local z2 = fallenBlock.z + z - 1 + zMove
            local x2 = fallenBlock.x + x - 1 + xMove

            if var2 ~= 0 then
                if validDrawPoint(x2, z2) then
                else
                    ratatable = false
                end
            end
        end
    end
    return ratatable
end

local function waitFall()
    -- 下入力でソフトドロップ（そのフレームで強制落下）
    if input.pressedDown() or input.pressedUp() then
        LevelManager.inputFall()
    end

    -- 落下フレームをカウントアップ
    -- 上下入力してたら確実にtrueが返ってくる
    fall = LevelManager.countUpFallFrame()

    local fallDistance = LevelManager.fallDistance
    if input.pressedUp() then
        --ハードドロップなら即一番下まで行く
        fallDistance = 20
    end

    -- 上入力でハードドロップ（固定時間も０で）

    -- 自然落下
    if fall then
        local distance = 0
        for i = 1, fallDistance do
            if tryRotationWithSuperRotation(0, i, fallenBlock.block) then
                distance = i
            else
                -- 近い落下距離から計算して無理になる直前の落下距離をとる
                break
            end
        end
        --print(distance)
        fallenBlock.z = fallenBlock.z + distance
    end

    --ハードドロップならさらに瞬間接着（直前に表示変更ロジック入れる）
    if input.pressedUp() then
        updateAreaView()
        changePlayingState(PlayingStateEnum.Locked)
    end
end

-- 接着中ブロックが固まるまでの処理
local function waitAdhesive()
    -- 固定時間をカウントアップ
    local locked = LevelManager.countUpGlueFrame()

    -- 下入力で強制固定
    -- 上入力でも強制固定
    if input.pressedDown() or input.pressedUp() then
        locked = true
    end

    -- 固定
    if locked then
        changePlayingState(PlayingStateEnum.Locked)
    end
end

local superRotationData = {
    {0, 0},
    {1, 0},
    {-1, 0},
    {0, 1},
    {1, 1},
    {-1, 1},
    {2, 0},
    {-2, 0},
    {2, 1},
    {-2, 1}
}

--入力回転、スーパーローテーションも見る
local function rotateAndMoveBlock()
    local clockWise = false
    local reverseWise = false

    -- ボタンの入力確認 同時押しなら〇ボタンゆうせん
    if input.pressCircle() then
        reverseWise = true
    elseif input.pressCross() then
        clockWise = true
    end

    --fallenBlock
    -- 回転入力していなければ回転処理を行わない
    if clockWise or reverseWise then
        -- 回転後の形と位置
        local b = {}
        if clockWise then
            b = fallenBlock.getclockWiseShape()
        elseif reverseWise then
            b = fallenBlock.getcReverseShape()
        end

        --下端を基準として開店するために回転後の位置をブロックのたいぷによってちょうせいする
        --if fallenBlock.

        -- 回転可能かどうか見る
        -- 横方向で問題あればスーパーローテーションのチェック
        -- 両端でダメなら回転できない

        local upperSlide = 0
        local sideSlide = 0
        -- ブロックの回転先の情報で回転できるかチェックする
        local ratatable = false

        for z, var in ipairs(superRotationData) do
            sideSlide = var[1]
            upperSlide = var[2]

            if tryRotationWithSuperRotation(sideSlide, upperSlide, b) then
                ratatable = true
                break
            end
        end

        -- 回転とスーパーローションでの移動
        if ratatable then
            fallenBlock.x = fallenBlock.x + sideSlide
            fallenBlock.z = fallenBlock.z + upperSlide
            if clockWise then
                fallenBlock.rotateclockWise()
            elseif reverseWise then
                fallenBlock.rotateReverse()
            end
        end
    end
end

-- 入力による左右移動
local function inputMove()
    -- 移動入力チェック（横方向のみ）
    local sideMove = 0

    -- 左右入力：右優先
    if input.pressRight() or input.pressingRight() then
        sideMove = 1
    elseif input.pressLeft() or input.pressingLeft() then
        sideMove = -1
    end

    if sideMove ~= 0 then
        movable = tryRotationWithSuperRotation(sideMove, 0, fallenBlock.block)

        --移動
        if movable then
            fallenBlock.x = fallenBlock.x + sideMove
        end
    end
end

--落下中～固定までのupdate
-- ブロックが生成されたフレームでも行う
local function fallingUpdate()
    -- 入力によってホールドいf
    if input.pressSquare() and NextAndHold.getCanHold() then
        holdBlockSpawn()
    end

    -- 入力による回転を行う　スーパーローテーションも行う
    rotateAndMoveBlock()
    -- 入力による移動
    inputMove()

    --　落下可能かチェック
    local canFall = tryRotationWithSuperRotation(0, 1, fallenBlock.block)

    if canFall then
        -- 落下処理
        waitFall()
    else
        -- 接着中のupdate
        waitAdhesive()
    end
end

function MainGame.Start(level)
    -- ブロックの移動範囲１10*20の箱を作る
    local world = SimpleProject.world
    local blockFactory = require "script/lua/MainGame/BlockUnit"
    for z = 1, 20 do
        --VIewとモデルをわける
        RowView = nil or {}
        RowModel = nil or {}
        LockRowMOdel = nil or {}
        for x = 1, 10 do
            local view_position = Vector3(x - .5, 0, 20.5 - z)
            local unit = blockFactory.Create(view_position)
            table.insert(RowView, unit)

            local visible = 0
            table.insert(RowModel, visible)

            local visible = 0
            table.insert(LockRowMOdel, visible)
        end
        table.insert(AreaView, RowView)
        table.insert(AreaModel, RowModel)
        table.insert(AreaLockModel, LockRowMOdel)
    end

    local maingame = MainGame()

    -- レベル,落下フレームの管理
    LevelManager = require "script/lua/MainGame/LevelManager"

    --音
    SoundManager = require "script/lua/Sound/SoundManager"
    SoundManager.play_Game_Music()
    -- にゅうりょくの準備
    input = require "script/lua/MainGame/InputData"
    input.Start(SimpleProject.level)

    -- next hold
    NextAndHold = require "script/lua/MainGame/NextAndHold"
    NextAndHold.Start()


    gameUI:init()

    spwanBlock()

    --Updateとかを登録
    Appkit.manage_level_object(level, MainGame, maingame)
end

local function lockedBlock()
    -- ブロック情報を落下中から固定にコピーする
    -- エリア列チェック
    -- ライン削除
    -- ライン移動
    -- 次のブロックの落下
end

local function lockedUpdate()
    -- 最初のフレームに
    lockedBlock()

    -- 待ち時間後に次のブロックが落ちてくる
end

local function PlayingUpdate(self, dt)
    --ボタンの状態をしゅとくする
    input.update(dt)
    -- げーむのじょうたいでかんすうを変更する
    if playingState == PlayingStateEnum.Falling then
        --フレームの最後にview更新
        fallingUpdate()
    elseif playingState == PlayingStateEnum.Locked then
    elseif playingState == PlayingStateEnum.DeleteLine then
        if LevelManager.countupWaitFrame() then
            changePlayingState(PlayingStateEnum.Falling)
        end
    elseif playingState == PlayingStateEnum.WaitNextPop then
        if LevelManager.countupWaitFrame() then
            changePlayingState(PlayingStateEnum.Falling)
        end
    end
    updateAreaView()
end

function MainGame.update(self, dt)
    -- げーむのじょうたいでかんすうを変更する
    if gameState == GameStateEnum.Start then
    elseif gameState == GameStateEnum.Playing then
        PlayingUpdate(self, dt)
    elseif gameState == GameStateEnum.End then
    elseif gameState == GameStateEnum.Paused then
    end
end

function MainGame.shutdown(self, level)
    -- ゲーム終了時
    --中身がなくてもmanage_level_objectしたら関数が必要っぽい
    --なければシャットダウン時えらーになる
end

return MainGame
