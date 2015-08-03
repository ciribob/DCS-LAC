--[[

    Late Activation Script

    Makes it possible to enable and disable playable aircraft using flags

    If an aircraft if disabled, a message will be shown to the user  and the aircraft destroyed after 10 seconds
    if a specified flat isn't set.

    To Setup, load this Script as a DO SCRIPT FILE at mission start

    Call lac.disableAircraft("heli 1", 1000,"This aircraft cannot be used yet. In 10 seconds you will be removed from the Aircraft") as a DO SCRIPT after loading the file

    Where "heli 1" is the NAME of the unit to disable, 1000 is the flag it keeps checking until its true, and the final argument
    is the message to display to the user.

    Warning: If the flag is later set to FALSE, the player will be thrown out of the aircraft

    You can also reserve aircraft using:

    lac.reserveAircraft("Impala 1", "VSAAF","Sorry this aircraft is for VSAAF members only!") as a DO SCRIPT

 ]]
lac = nil
lac = {}

function lac.disableAircraft(_name, _flagNumber,_message)

    local _args = {name = _name,flagNumber = _flagNumber,message = _message }

    if  trigger.misc.getUserFlag(_flagNumber)  <= 0 then

        local _unit = lac.getUnit(_name)

        if  _unit ~=  nil then

            --display message,
            lac.displayMessageToGroup(_unit, _message, 10)
            --destroy in 10 seconds
            timer.scheduleFunction(lac.destroyUnit, _name, timer.getTime() + 10)

            --queue up in 12 seconds

            timer.scheduleFunction(lac.disableAircraftScheduled, _args, timer.getTime() + 12)
            return
        end
    end

    timer.scheduleFunction(lac.disableAircraftScheduled, _args, timer.getTime() + 5)

end

function lac.reserveAircraft(_name, _clanTag,_message)

    --lowercase
    _clanTag = string.lower(_clanTag)

    local _args = {name = _name,clanTag = _clanTag,message = _message }

    local _unit = lac.getUnit(_name)

    if  _unit ~=  nil then

        local _playerName = string.lower(lac.getPlayerName(_unit))

        if not  string.match(_playerName, _clanTag) then
            --display message,
            lac.displayMessageToGroup(_unit, _message, 10)
            --destroy in 10 seconds
            timer.scheduleFunction(lac.destroyUnit, _name, timer.getTime() + 10)

            --queue up in 12 seconds

            timer.scheduleFunction(lac.reserveAircraftScheduled, _args, timer.getTime() + 12)
            return
        end
    end

    timer.scheduleFunction(lac.reserveAircraftScheduled, _args, timer.getTime() + 1)

end

----------------------------------- INTERNAL FUNCTIONS ---------------------------------------

function lac.disableAircraftScheduled(_args)

    lac.disableAircraft(_args.name, _args.flagNumber,_args.message)
end

function lac.reserveAircraftScheduled(_args)

    lac.reserveAircraft(_args.name, _args.clanTag,_args.message)
end

function lac.displayMessageToGroup(_unit, _text, _time)

    trigger.action.outTextForGroup(_unit:getGroup():getID(), _text, _time)
end

function lac.destroyUnit(_unitName)
    local _unit = lac.getUnit(_unitName)

    if _unit ~= nil then
        _unit:destroy()
    end


end

function lac.getUnit(_unitName)

    if _unitName == nil then
        return nil
    end

    local _heli = Unit.getByName(_unitName)

    if _heli ~= nil and _heli:isActive() and _heli:getLife() > 0 then

        return _heli
    end

    return nil
end

function lac.getPlayerName(_heli)

    if _heli:getPlayerName() == nil then

        return ""
    else
        return _heli:getPlayerName()
    end
end

