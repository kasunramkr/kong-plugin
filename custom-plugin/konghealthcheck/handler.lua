local konghealthcheck = {
  PRIORITY = 1005,
  VERSION = "2.2.0"
}

function konghealthcheck:access(conf)
    kong.log.debug("HEALTHCHECK EXECUTED")
    kong.response.exit(200, '{"status": "UP"}', {["Content-Type"] = "application/json"})
end



return konghealthcheck
