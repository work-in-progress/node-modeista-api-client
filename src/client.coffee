# (C) 2012 Modeista, Inc.

request = require 'request'
_ = require 'underscore'
StyleEventMethods = require './style-event-methods'
ChannelMethods = require './channel-methods'

module.exports = class Client
  constructor: (@endpoint, @options = {}) ->
    @endpoint = @_cleanEndpoint(@endpoint)
    throw new Error("Endpoint required") unless @endpoint && @endpoint.length > 0

    _.defaults @options,
            maxCacheItems: 1000
            maxTokenCache: 60 * 10
            clientId : null
            bearerToken: null # If present will be added to the request header as a
                              # bearer token (using current draft)
            headers: {}
    @cache = {}

    @styleEvents  = new StyleEventMethods @
    @channels = new ChannelMethods @

  _cleanEndpoint: (endpoint) =>
    return null unless endpoint
    endpoint.replace /\/+$/, ""


  _handleResult: (res, bodyBeforeJson, callback) =>
      return callback new Error("Forbidden") if res.statusCode is 401 or res.statusCode is 403

      body = null

      #console.log "WE ARE HERE #{bodyBeforeJson}"
      if bodyBeforeJson and bodyBeforeJson.length > 0
        try
          body = JSON.parse(bodyBeforeJson)
        catch e
          return callback( new Error("Invalid Body Content"), bodyBeforeJson, res.statusCode)

      return callback(new Error(if body then body.message else "Request failed.")) unless res.statusCode >= 200 && res.statusCode < 300
      callback null, body, res.statusCode

  _reqWithData: (method, path, params, data, headers = {}, actor, callback) =>
    headers['Content-Type'] = 'application/json' if data
    headers['Accept'] = 'application/json'
    headers['authorization'] = "Bearer #{@options.bearerToken}" if @options.bearerToken
    headers['X-ClientId'] = @options.clientId if @options.clientId

    _.extend headers, @options.headers

    request
      uri: "#{@endpoint}#{path}"
      headers: headers
      body: if data then JSON.stringify data else null
      method: method
      timeout: 2000
     , (err, res, body) =>
       if err
         err.status =  if res && res.statusCode then res.statusCode else 503
         return callback(err)

       @_handleResult res, body, callback


  post: (path, data, actor, callback) =>
    @_reqWithData "POST", path, null, data, null, actor, callback

  patch: (path, data, actor, callback) =>
    @_reqWithData "PATCH", path, null, data, null, actor, callback

  put: (path, data, actor, callback) =>
    @_reqWithData "PUT", path, null, data, null, actor, callback

  delete: (path, params, actor, callback) =>
    @_reqWithData "DELETE", path, params, null, null, actor, callback

  get: (path, params, actor, callback) =>
    @_reqWithData "GET", path, params, null, null, actor, callback
