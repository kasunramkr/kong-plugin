local body_transformer = require "kong.plugins.response-transformer.body_transformer"

local is_json_body = body_transformer.is_json_body

local kongbodyinspection = {
  PRIORITY = 1005,
  VERSION = "1.0.0"
}

function kongbodyinspection:access(conf)
    kong.log.debug("#############INSIDE kongbodyinspection###############")
    local scheme = kong.request.get_scheme()
    kong.log.debug(scheme)
    if is_json_body(kong.request.get_header("Content-Type")) then

        local body, err, mimetype = kong.request.get_body()
        local message = nil

        if body ~= nil then
            if body.message ~= nil and body.message[1] ~= nil and body.message[1].text ~= nil and body.message[1].type == "text" then
                message = body.message[1].text.body
                kong.log.debug(message)
            end

            if body.rooms ~= nil and body.rooms.join ~=nil then
                local extractData
                for k,v in pairs(body.rooms.join) do
                    extractData = v
                    break
                end

                if extractData ~= nil and extractData.timeline ~= nil and extractData.timeline.events ~= nil and extractData.timeline.events[1] ~= nil
                        and extractData.timeline.events[1].content ~= nil and extractData.timeline.events[1].content.body then
                    message = extractData.timeline.events[1].content.body
                end
                kong.log.debug(message)
            end
        end

        if message ~= nil then
            local imgAttackPattern = "<[iI][mM][gG].?>"
            local orAttackPattern = "'%s*[oO][rR]"
            local sqlDeleteAttackPattern = "'%s*;%s*[dD][eE][lL][eE][tT][eE]"
            local sqlDropTableAttackPattern = "'%s*;%s*[dD][rR][oO][pP]%s*[tT][aA][bB][lL][eE]"
            local sqlInsertAttackPattern = "'%s*;%s*[iI][nN][sS][eE][rR][tT]"
            local sqlServerShutdownAttackPattern = "'%s*;%s*[sS][hH][uU][tT][dD][oO][wW][nN]%s*[wW][iI][tT][hH]%s*[nN][oO][wW][aA][iI][tT]"
            local sqlUpdateAttackPattern = "'%s*;%s*[uU][pP][dD][aA][tT][eE]"
            local svgAttackPattern = "<[sS][vV][gG].?>"
            local scriptAttackPattern = "<[sS][cC][rR][iI][pP][tT].?>"
            if string.match (message, imgAttackPattern) then
                kong.response.exit(550, '{"code": "IMG_ATTACK" ,"error": "Img attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (message, orAttackPattern) then
                kong.response.exit(551, '{"code": "OR_ATTACK" ,"error": "Or attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (message, sqlDeleteAttackPattern) then
                kong.response.exit(552, '{"code": "SQL_DELETE_ATTACK" ,"error": "SQL delete attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (message, sqlDropTableAttackPattern) then
                kong.response.exit(553, '{"code": "SQL_DROP_TABLE_ATTACK" ,"error": "SQL drop table attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (message, sqlInsertAttackPattern) then
                kong.response.exit(554, '{"code": "SQL_INSERT_ATTACK" ,"error": "SQL insert attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (message, sqlServerShutdownAttackPattern) then
                kong.response.exit(555, '{"code": "SQL_SERVER_SHUTDOWN_ATTACK" ,"error": "SQL server shutdown attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (message, sqlUpdateAttackPattern) then
                kong.response.exit(556, '{"code": "SQL_UPDATE_ATTACK" ,"error": "SQL update attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (message, svgAttackPattern) then
                kong.response.exit(557, '{"code": "SVG_ATTACK" ,"error": "Svg attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (message, scriptAttackPattern) then
                kong.response.exit(558, '{"code": "SCRIPT_ATTACK" ,"error": "Script attack detected"}', {["Content-Type"] = "application/json"})
            end
        end
    end

end



return kongbodyinspection
