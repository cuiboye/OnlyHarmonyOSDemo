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

  /**
   * 检查是否申请了权限
   * @param permission
   * @returns
   */
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

  static async checkPermissions(context:common.UIAbilityContext,permissions: Array<Permissions>): Promise<void> {
    let grantStatus: abilityAccessCtrl.GrantStatus = await PermissionUtils.checkAccessToken(permissions);

    if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
      // 已经授权，可以继续访问目标操作
      console.log("已经授权")
      prompt.showToast({
        message: '已经授权'
      })
    } else {
      // 申请日历权限
      console.log("未申请授权")
      prompt.showToast({
        message: '未申请授权'
      })

      PermissionUtils.reqPermissionsFromUser(context,permissions)
    }
  }

  static reqPermissionsFromUser(context:common.UIAbilityContext,permissions: Array<Permissions>): void {
    let atManager = abilityAccessCtrl.createAtManager();
    // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: Array<number> = data.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] === 0) {
          // 用户授权，可以继续访问目标操作
          console.log('用户已经授权')
          prompt.showToast({
            message: '用户已经授权'
          })
        } else {
          // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
          console.log('用户已经拒绝授权，请在设置中打开对应的权限')
          prompt.showToast({
            message: '用户已经拒绝授权，请在设置中打开对应的权限'
          })
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

    })
  }
}