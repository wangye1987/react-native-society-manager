import { DeviceEventEmitter, NativeModules, Platform} from 'react-native';
import { EventEmitter } from 'events';
import { promises } from 'fs';
import { resolve } from 'url';
import { rejects } from 'assert';
import { async } from 'rxjs/internal/scheduler/async';
import { EROFS } from 'constants';

const SocietyManager = NativeModules.SocietyManager;

const emitter = new EventEmitter();

DeviceEventEmitter.addListener('SocietyLogin_Resp', resp => {
  emitter.emit(resp.type, resp);
});

export enum platformType{
    MTDWexinPlatform = 0,
}

export interface AuthResponse {
    errCode?: number;
    errStr?: string;
    openId?: string;
    code?: string;
    url?: string;
    lang?: string;
    country?: string;
    platform?: string;
  }

/**
 * Return if the wechat app is installed in the device.
 * @method isAppInstalled
 * @param  {number} platform
 * @return {Promise}
 */
export async function isAppInstalled(platform:platformType):Promise<boolean>{

    let isInstalled = await SocietyManager.isAppInstalled(platform);
    return new Promise((resolve,rejects)=>{
        if(isInstalled){
            resolve(isInstalled);
        }else{
            rejects(new Error('check failed'));
        }
    });
}

/**
 * @method registerApp
 * @param {String} appid - the app id
 * @param {number} platform 
 * @return {Promise}
 */
export async function registerApp(appid:string,platform:platformType):Promise<boolean>{
    let isRegister = await SocietyManager.registerApp(appid,platform);
    return new Promise((resolve,rejects)=>{
        if(isRegister){
            resolve(isRegister)
        }else{
            rejects(new Error('register fail'));
        }
    });
}

/**
 * @method sendAuthRequest
 * @param  {number}platform
 * @return {Promise}
 */
export async function sendAuthRequest(platform:platformType):Promise<AuthResponse> {
    let isSend = await SocietyManager.sendAuthRequest(platform);

    return new Promise((resolve,rejects)=>{
        emitter.once('SendAuth.Resp', resp => {
            if (resp.errCode === 0) {
              resolve(resp);
            } else {
              rejects(new Error('Auth fail'));
            }
          });
    })
}


