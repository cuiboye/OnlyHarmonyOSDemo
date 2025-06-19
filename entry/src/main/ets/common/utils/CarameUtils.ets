import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import prompt from '@ohos.prompt';
import bundleManager from '@ohos.bundle.bundleManager';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 拍照工具类
 */
export default class CarameUtils{
  /**
   * 是否申请了拍照权限
   */
  static async checkPermissions(context:common.UIAbilityContext,permissions: Array<Permissions>): Promise<void> {
    let grantStatus: abilityAccessCtrl.GrantStatus = await CarameUtils.checkAccessToken(permissions);

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

      CarameUtils.reqPermissionsFromUser(context,permissions)
    }
  }

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
    }).catch((err:BusinessError) => {
      console.error(`requestPermissionsFromUser failed, code is ${err.code}, message is ${err.message}`);
    })
  }

  /**
   * 拍照
   */
  static takePhoto(){
    //todo 涉及到相机的一些api在版本9上面无法使用
  }

  static getReceived(){

  }
}