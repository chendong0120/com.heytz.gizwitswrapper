/********* gwsdkSetDeviceWifi.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <XPGWifiSDK/XPGWifiSDK.h>

@interface gwsdkwrapper: CDVPlugin<XPGWifiSDKDelegate> {
    // Member variables go here.
    NSString * _appId;
}

-(void)setDeviceWifi:(CDVInvokedUrlCommand *)command;

@property (strong,nonatomic) CDVInvokedUrlCommand * commandHolder;

@end

@implementation gwsdkwrapper

@synthesize commandHolder;

-(void)pluginInitialize{
}

-(void)initSdkWithAppId:(CDVInvokedUrlCommand *) command{
    if(!_appId){
        _appId = command.arguments[2];
        [XPGWifiSDK startWithAppID:_appId];
    }
}

-(void) setDelegate{
    if(!([XPGWifiSDK sharedInstance].delegate)){
        [XPGWifiSDK sharedInstance].delegate = self;
    }
}

-(void)setDeviceWifi:(CDVInvokedUrlCommand *)command
{
    [self initSdkWithAppId:command];
    [self setDelegate];
    self.commandHolder = command;
    
    /**
     * @brief 配置路由的方法
     * @param ssid：需要配置到路由的SSID名
     * @param key：需要配置到路由的密码
     * @param mode：配置方式 SoftAPMode=软AP模式 AirLinkMode=一键配置模式
     * @param softAPSSIDPrefix：SoftAPMode模式下SoftAP的SSID前缀或全名（XPGWifiSDK以此判断手机当前是否连上了SoftAP，AirLinkMode该参数无意义，传nil即可）
     * @param timeout: 配置的超时时间 SDK默认执行的最小超时时间为30秒
     * @see 对应的回调接口：[XPGWifiSDK XPGWifiSDK:didSetDeviceWifi:result:]
     */
    // self.commandHolder = command;
    // [[XPGWifiSDK sharedInstance] setDeviceWifi:command.arguments[0]
    //                                        key:command.arguments[1]
    //                                       mode:XPGWifiSDKAirLinkMode
    //                           softAPSSIDPrefix:nil timeout:59];
    
    /**
     配置设备连接路由的方法
     @param ssid 需要配置到路由的SSID名
     @param key 需要配置到路由的密码
     @param mode 配置方式
     @see XPGConfigureMode
     @param softAPSSIDPrefix SoftAPMode模式下SoftAP的SSID前缀或全名（XPGWifiSDK以此判断手机当前是否连上了SoftAP，AirLink配置时该参数无意义，传nil即可）
     @param timeout 配置的超时时间 SDK默认执行的最小超时时间为30秒
     @param types 配置的wifi模组类型列表，存放NSNumber对象，SDK默认同时发送庆科和汉枫模组配置包；SoftAPMode模式下该参数无意义。types为nil，SDK按照默认处理。如果只想配置庆科模组，types中请加入@XPGWifiGAgentTypeMXCHIP类；如果只想配置汉枫模组，types中请加入@XPGWifiGAgentTypeHF；如果希望多种模组配置包同时传，可以把对应类型都加入到types中。XPGWifiGAgentType枚举类型定义SDK支持的所有模组类型。
     @see 对应的回调接口：[XPGWifiSDKDelegate XPGWifiSDK:didSetDeviceWifi:result:]
     */
    [[XPGWifiSDK sharedInstance] setDeviceWifi:command.arguments[0]
                                           key:command.arguments[1]
                                          mode:XPGWifiSDKAirLinkMode
                              softAPSSIDPrefix:nil
                                       timeout:119
                                wifiGAgentType:[NSArray arrayWithObjects:[NSNumber numberWithInt: XPGWifiGAgentTypeHF], nil]
     ];
}

/**
 * @brief 回调接口，返回设备配置的结果
 * @param device：已配置成功的设备
 * @param result：配置结果 成功 - 0 或 失败 - 1 如果配置失败，device为nil
 * @see 触发函数：[XPGWifiSDK setDeviceWifi:key:mode:]
 */
- (void)XPGWifiSDK:(XPGWifiSDK *)wifiSDK didSetDeviceWifi:(XPGWifiDevice *)device result:(int)result{
    if(result == 0  && device.did.length > 0) {
        // successful
        NSLog(@"======did===%@", device.did);
        NSLog(@"======passCode===%@", device.passcode);
        NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:
                           device.did, @"did",
                           device.ipAddress, @"ipAddress",
                           device.macAddress, @"macAddress",
                           device.passcode, @"passcode",
                           device.productKey, @"productKey",
                           device.productName, @"productName",
                           device.remark, @"remark",
                           //device.isConnected, @"isConnected",
                           //                           device.isDisabled, @"isDisabled",
                           //                           device.isLAN, @"isLAN",
                           //                           device.isOnline, @"isOnline",
                           @"",@"error",
                           nil];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:d];
        //[pluginResult setKeepCallbackAsBool:false];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.commandHolder.callbackId];
    }else if(result == XPGWifiError_CONFIGURE_TIMEOUT){
        [self.commandDelegate sendPluginResult:[CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR] callbackId:self.commandHolder.callbackId];
    }
}

- (void)dealloc
{
    NSLog(@"//====dealloc...====");
    [XPGWifiSDK sharedInstance].delegate = nil;
}


- (void)dispose{
    NSLog(@"//====disposed...====");
}
@end
