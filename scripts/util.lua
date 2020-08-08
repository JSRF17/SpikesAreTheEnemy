util = {}

function util:verySmall(number)
    return number < 0.001 and number > -0.001
end

function util:notZero(number)
    return number > 0.001 or number < -0.001
end
