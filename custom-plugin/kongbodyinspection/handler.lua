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
    ngx.redirect("https://endpoint3.free.beeceptor.com")
    if is_json_body(kong.request.get_header("Content-Type")) then

        local body, err, mimetype = kong.request.get_body()
        if body ~= nil and body.message ~= nil and body.message[1] ~= nil and body.message[1].text ~= nil then
            local wa_message = body.message[1].text.body

            kong.log.debug(wa_message)
            local deletePattern = "'%s*;%s*[dD][eE][lL][eE][tT][eE]"
            local insertPattern = "'%s*;%s*[iI][nN][sS][eE][rR][tT]"
            if string.match (wa_message,
                    deletePattern) then
                kong.response.exit(550, '{"code": "SQL_INJECTION_DELETE" ,"error": "SQL delete detected"}', {["Content-Type"] = "application/json"})
            elseif string.match (wa_message, insertPattern) then
                kong.response.exit(551, '{"code": "SQL_INJECTION_INSERT" ,"error": "SQL insert detected"}', {["Content-Type"] = "application/json"})
            end
        end
    end

end



return kongbodyinspection
