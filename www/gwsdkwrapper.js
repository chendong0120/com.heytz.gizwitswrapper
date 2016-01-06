var exec = require('cordova/exec');

exports.setDeviceWifi = function (appid,productKey,wifiSSID,wifiKey, success, error) {
    exec(success, error, "gwsdkwrapper", "setDeviceWifi", [appid,productKey,wifiSSID,wifiKey]);
};
exports.getDeviceList = function (appid,productKey,uid,token, success, error) {
    exec(success, error, "gwsdkwrapper", "getDeviceList", [appid,productKey,uid,token]);
};
exports.deviceControl = function (appid,productKey,uid,token,mac,value, success, error) {
    exec(success, error, "gwsdkwrapper", "deviceControl", [appid,productKey,uid,token,mac,value]);
};

exports.deAlloc = function(success, error){
    exec(success, error, "gwsdkwrapper", "dealloc",[]);
};
