local typedefs = require "kong.db.schema.typedefs"


return {
    name = "kongbodyinspection",
    fields = {
        {
            config = {
                type = "record",
                fields = {
                    {  token_required = { type     = "string", required = false, default  = "true" }, }
                },
            },
        },
    },
}
