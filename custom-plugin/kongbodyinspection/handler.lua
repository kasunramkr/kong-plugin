local body_transformer = require "kong.plugins.response-transformer.body_transformer"
local ngx = require "ngx"

local is_json_body = body_transformer.is_json_body

local kongbodyinspection = {
  PRIORITY = 1005,
  VERSION = "2.2.0"
}

function kongbodyinspection:access(conf)
    kong.log.debug("INSIDE kongbodyinspection")
    local scheme = kong.request.get_scheme()
    kong.log.debug(scheme)
    --ngx.redirect("https://endpoint3.free.beeceptor.com")
    if is_json_body(kong.request.get_header("Content-Type")) then

        local body, err, mimetype = kong.request.get_body()
        if body ~= nil and body.message ~= nil and body.message[1] ~= nil and body.message[1].text ~= nil then
            local wa_message = body.message[1].text.body
            kong.log.debug(wa_message)

            local imgAttackPattern = "<[iI][mM][gG].?>"
            local orAttackPattern = "'%s*[oO][rR]"
            local sqlDeleteAttackPattern = "'%s*;%s*[dD][eE][lL][eE][tT][eE]"
            local sqlDropTableAttackPattern = "'%s*;%s*[dD][rR][oO][pP]%s*[tT][aA][bB][lL][eE]"
            local sqlInsertAttackPattern = "'%s*;%s*[iI][nN][sS][eE][rR][tT]"
            local sqlServerShutdownAttackPattern = "'%s*;%s*[sS][hH][uU][tT][dD][oO][wW][nN]%s*[wW][iI][tT][hH]%s*[nN][oO][wW][aA][iI][tT]"
            local sqlUpdateAttackPattern = "'%s*;%s*[uU][pP][dD][aA][tT][eE]"
            local svgAttackPattern = "<[sS][vV][gG].?>"
            local scriptAttackPattern = "<[sS][cC][rR][iI][pP][tT].?>"
            if string.match (wa_message, imgAttackPattern) then
                kong.response.exit(550, '{"code": "IMG_ATTACK" ,"error": "Img attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (wa_message, orAttackPattern) then
                kong.response.exit(551, '{"code": "OR_ATTACK" ,"error": "Or attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (wa_message, sqlDeleteAttackPattern) then
                kong.response.exit(552, '{"code": "SQL_DELETE_ATTACK" ,"error": "SQL delete attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (wa_message, sqlDropTableAttackPattern) then
                kong.response.exit(553, '{"code": "SQL_DROP_TABLE_ATTACK" ,"error": "SQL drop table attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (wa_message, sqlInsertAttackPattern) then
                kong.response.exit(554, '{"code": "SQL_INSERT_ATTACK" ,"error": "SQL insert attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (wa_message, sqlServerShutdownAttackPattern) then
                kong.response.exit(555, '{"code": "SQL_SERVER_SHUTDOWN_ATTACK" ,"error": "SQL server shutdown attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (wa_message, sqlUpdateAttackPattern) then
                kong.response.exit(556, '{"code": "SQL_UPDATE_ATTACK" ,"error": "SQL update attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (wa_message, svgAttackPattern) then
                kong.response.exit(557, '{"code": "SVG_ATTACK" ,"error": "Svg attack detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (wa_message, scriptAttackPattern) then
                kong.response.exit(558, '{"code": "SCRIPT_ATTACK" ,"error": "Script attack detected"}', {["Content-Type"] = "application/json"})
            end
        end
    end

end



return kongbodyinspection
