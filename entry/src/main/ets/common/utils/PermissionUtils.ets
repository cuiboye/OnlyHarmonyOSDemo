import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import bundleManager from '@ohos.bundle.bundleManager';
import prompt from '@ohos.prompt';
import common from '@ohos.app.ability.common';
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 申请权限工具类
 */
export default class PermissionUtils {
  permissions: Array<Permissions> = ['ohos.permission.READ_CALENDAR'];

  private static readonly uri_info: string = 'application_info_entry'; // 应用设置页面的URI

  static async checkAccessToken(permissions: Array<Permissions>): Promise<abilityAccessCtrl.GrantStatus> {
    let atManager = abilityAccessCtrl.createAtManager();
    let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;

    // 获取应用程序的accessTokenID
    let tokenId: number = 0;
    try {
      let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (err) {
      console.error(`getBundleInfoForSelf failed, code is ${err.code}, message is ${err.message}`);
    }

    // 校验应用是否被授予权限
    try {
      grantStatus = await atManager.checkAccessToken(tokenId, permissions[0]);
    } catch (err) {
      console.error(`checkAccessToken failed, code is ${err.code}, message is ${err.message}`);
    }
    return grantStatus;
  }

  /**
   * 检查是否申请了权限
   * @param permission
   * @returns
   */
  static async checkPermissions(context:common.UIAbilityContext,permissions: Array<Permissions>,callback?:AuthorizationInterface): Promise<void> {
    let grantStatus: abilityAccessCtrl.GrantStatus = await PermissionUtils.checkAccessToken(permissions);

    if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      // 已经授权，可以继续访问目标操作
      console.log("已经授权")
      prompt.showToast({
        message: '已经授权'
      })
      callback?.successAuthorization()
    } else {
      console.log("未申请授权")
      prompt.showToast({
        message: '未申请授权'
      })

      PermissionUtils.reqPermissionsFromUser(permissions,callback)
    }
  }

  /**
   * 监听允许和不允许权限，requestPermissionsFromUser会弹出一个弹框
   */
  static reqPermissionsFromUser(permissions: Array<Permissions>,callback?:AuthorizationInterface): void {
    let atManager = abilityAccessCtrl.createAtManager();
    let context: Context = getContext() as common.UIAbilityContext
    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          // 用户授权成功，点击了“允许”，可以继续访问目标操作
          callback?.successAuthorization()
        } else {
          //注意：这个回调方法会执行两次
          // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
          callback?.refuseAuthorization()
          return;
        }
      }
      // 授权成功
    }).catch((err:BusinessError) => {//BusinessError相当于Android中的Exception
      console.error(`requestPermissionsFromUser failed, code is ${err.code}, message is ${err.message}`);
    })
  }

  /**
   * 打开设置页面，手动开启权限
   * 这个方法不能跳转到应用的设置页面了
   */
  static openPermissionsInSystemSettings(context:common.UIAbilityContext): void {
    let wantInfo:Want = {
      action: 'action.settings.app.info',
      parameters: {
        settingsParamBundleName: 'com.example.myapplication' // 打开指定应用的权限详情页面
      }
    }
    context.startAbility(wantInfo).then(() => {
     //从设置页面返回的逻辑处理：检查下是否开启了对应的权限
    }).catch((err:BusinessError) => {
      console.log(`${err}}`)
    })
  }

  /**
   * 跳转应用设置页面（调用此方法到设置，手动开启权限）
   * @param uri 设置页面的URI，默认为应用设置页面的URI
   * @returns 返回一个Promise，该Promise解析为void
   */
  static async toAppSetting(context:common.UIAbilityContext): Promise<void> {
    // 创建Want对象，用于描述跳转意图
    let want: Want = {
      bundleName: 'com.huawei.hmos.settings', // 设置应用bundleName
      abilityName: 'com.huawei.hmos.settings.MainAbility', // 设置应用abilityName
      uri: PermissionUtils.uri_info, // 目标页面URI
      parameters: {
        bundleName: context.abilityInfo.bundleName, // 拉起方应用包名
        pushParams: context.abilityInfo.bundleName, // 拉起方应用包名
      }
    }
    // 使用上下文信息启动设置应用
    return await context.startAbility(want);
  }

  /**
   * 是否开启了权限，纯判断没有弹框
   */
  static checkPermissionEnable(permissionName: Permissions): boolean {
    const BundleFlag = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION
    const bundleInfo = bundleManager.getBundleInfoForSelfSync(BundleFlag)
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let tokenID: number = bundleInfo.appInfo.accessTokenId;
    let data: abilityAccessCtrl.GrantStatus = atManager.checkAccessTokenSync(tokenID, permissionName);
    console.log(`data->${JSON.stringify(data)}`);
    return data == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED;
  }
}

export interface AuthorizationInterface{
  refuseAuthorization:()=>void
  successAuthorization:()=>void
}