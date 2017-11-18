--This script is executed on object creation
local thisActor = ...

local children    = scaleform.Actor.container(thisActor);
local labels      = scaleform.ContainerComponent.actor_by_name(children,"Labels");
local level    = scaleform.ContainerComponent.actor_by_name(scaleform.Actor.container(labels), "level");
-- local down_arrow  = scaleform.ContainerComponent.actor_by_name(scaleform.Actor.container(arrows), "down");
-- local left_arrow  = scaleform.ContainerComponent.actor_by_name(scaleform.Actor.container(arrows), "left");
-- local right_arrow = scaleform.ContainerComponent.actor_by_name(scaleform.Actor.container(arrows), "right");

scaleform.Stage.set_fps(30);
scaleform.Stage.set_view_scale_mode(scaleform.ViewScaleModes.ExactFit);

local customListener = scaleform.EventListener.create(customListener, function(e)
    
    
    print("update level aaaa")
    print(e.name)

-- 	if e.name == "keypressed" then
-- 	    local button = buttonActors[e.data]
-- 	    if button then
-- 	        scaleform.Actor.set_alpha_scale(button, pressed_alpha)
--         end
--  	end
 	
--  	if e.name == "keyreleased" then
-- 	    local button = buttonActors[e.data]
-- 	    if button then
-- 	        scaleform.Actor.set_alpha_scale(button, unpressed_alpha)
--         end
--  	end
end )
print("main ")
scaleform.EventListener.connect(customListener, thisActor, scaleform.EventTypes.Custom)
