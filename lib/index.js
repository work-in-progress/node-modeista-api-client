// Generated by CoffeeScript 1.3.3
(function() {
  var Client, _;

  _ = require('underscore');

  require('pkginfo')(module, 'version');

  Client = require('./client');

  module.exports = {
    Client: Client,
    client: function(options) {
      if (options == null) {
        options = {};
      }
      return new Client(options.endpoint, options);
    }
  };

}).call(this);