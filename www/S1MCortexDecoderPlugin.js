var exec = require('cordova/exec');

var PLUGIN_NAME = "S1MCortexDecoderPlugin";

var cortexDecoder = function() {};

cortexDecoder.startScanner = function (successCallback, failureCallback) {
    exec(successCallback, failureCallback, PLUGIN_NAME, 'startScanner', []);
};

cortexDecoder.stopScanner = function (successCallback, failureCallback) {
    exec(successCallback, failureCallback, PLUGIN_NAME, 'stopScanner', []);
};

module.exports = cortexDecoder;
