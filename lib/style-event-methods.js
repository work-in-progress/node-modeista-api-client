// Generated by CoffeeScript 1.3.3
(function() {
  var StyleEventMethods,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  module.exports = StyleEventMethods = (function() {

    function StyleEventMethods(apiClient) {
      this.apiClient = apiClient;
      this.get = __bind(this.get, this);

      if (!this.apiClient) {
        throw new Error("apiClient parameter is required");
      }
    }

    StyleEventMethods.prototype.get = function(styleEventId, cb) {
      if (cb == null) {
        cb = function() {};
      }
      return this.apiClient.get("/style-events/" + styleEventId, null, null, cb);
    };

    return StyleEventMethods;

  })();

}).call(this);