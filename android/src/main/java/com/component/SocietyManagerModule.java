
package com.component;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.component.Util.Constants;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.util.ArrayList;
import java.util.List;

public class SocietyManagerModule extends ReactContextBaseJavaModule implements IWXAPIEventHandler {

    private final ReactApplicationContext reactContext;

    public SocietyManagerModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    public boolean canOverrideExistingModule() {
        return true;
    }

    private static ArrayList<SocietyManagerModule> modules = new ArrayList<>();

    @Override
    public void initialize() {
        super.initialize();
        modules.add(this);
    }

    public static void handleIntent(Intent intent) {
        for (SocietyManagerModule mod : modules) {
            mod.api.handleIntent(intent, mod);
        }
    }

    @Override
    public void onCatalystInstanceDestroy() {
        super.onCatalystInstanceDestroy();
        if (api != null) {
            api = null;
        }
        modules.remove(this);
    }

    @Override
    public String getName() {
        return "SocietyManager";
    }

    public static boolean isWeixinInstalleds(Context context) {
        final PackageManager packageManager = context.getPackageManager();// 获取packagemanager
        List<PackageInfo> pinfo = packageManager.getInstalledPackages(0);// 获取所有已安装程序的包信息
        if (pinfo != null) {
            for (int i = 0; i < pinfo.size(); i++) {
                String pn = pinfo.get(i).packageName;
                if (pn.equals("com.tencent.mm")) {
                    return true;
                }
            }
        }
        return false;
    }

    @ReactMethod
    public void isAppInstalled(int platform, Promise promise) {
        if (api != null) {
            if (!isWeixinInstalleds(reactContext)) {
                promise.reject("", "您还未安装微信客户端");
            } else {
                promise.resolve(true);
            }
        } else {
            promise.reject("", "您还未安装微信客户端");
        }
    }

    @ReactMethod
    public void registerApp(String appid, int platform, Promise promise) {
        Constants.APP_ID = appid;
        regToWx(promise);
    }

    @ReactMethod
    public void sendAuthRequest(int platform, Promise promise) {
        if (api == null) {
            promise.reject("", "调取失败");
            return;
        }
        final SendAuth.Req req = new SendAuth.Req();
        req.scope = "snsapi_userinfo";
        req.state = "MTDC_wx_login";
        boolean isSuccess = api.sendReq(req);
        if (isSuccess) {
            promise.resolve(isSuccess);
        } else {
            promise.reject("", "调取认证失败");
        }
    }


    /*
     *
     * */
    public static boolean isWeixinInstalled(Context context) {
        final PackageManager packageManager = context.getPackageManager();// 获取packagemanager
        List<PackageInfo> pinfo = packageManager.getInstalledPackages(0);// 获取所有已安装程序的包信息
        if (pinfo != null) {
            for (int i = 0; i < pinfo.size(); i++) {
                String pn = pinfo.get(i).packageName;
                if (pn.equals("com.tencent.mm")) {
                    return true;
                }
            }
        }
        return false;
    }
    // APP_ID 替换为你的应用从官方网站申请到的合法appID

    // IWXAPI 是第三方app和微信通信的openApi接口
    public IWXAPI api;

    private void regToWx(Promise promise) {
        // 通过WXAPIFactory工厂，获取IWXAPI的实例
        api = WXAPIFactory.createWXAPI(reactContext, Constants.APP_ID, false);

        // 将应用的appId注册到微信
        boolean isSuccess = api.registerApp(Constants.APP_ID);
        if (isSuccess) {
            promise.resolve(isSuccess);
        } else {
            promise.reject("", " 注册失败");
        }
    }

    // TODO: 实现sendRequest、sendSuccessResponse、sendErrorCommonResponse、sendErrorUserCancelResponse

    @Override
    public void onReq(BaseReq baseReq) {

    }

    @Override
    public void onResp(BaseResp baseResp) {
        //定义发送事件的函数
        WritableMap map = Arguments.createMap();
        SendAuth.Resp resp = (SendAuth.Resp) (baseResp);
        if (resp.errCode == 0) {
            map.putInt("errCode", resp.errCode);
            map.putString("errStr", resp.errStr);
            map.putString("lang", resp.lang);
            map.putString("type", "SendAuth.Resp");
            map.putString("code", resp.code);
            map.putString("country", resp.country);
            map.putString("platform", "0");
        } else {
            map.putInt("errCode", resp.errCode);
        }
        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("SocietyLogin_Resp", map);
    }
}