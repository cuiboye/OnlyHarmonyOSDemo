/**
 * 访问权限申请
 */
import common from '@ohos.app.ability.common';
import { CommonHeader } from '../common/common_header';
import PermissionUtils from '../common/utils/PermissionUtils';
import userIAM_userAuth from '@ohos.userIAM.userAuth';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';

@HMRouter({ pageUrl: NavigationConstants.PERMISSIONS_PAGE })
@Component
export struct PermissionsPage {
  private context = getContext(this) as common.UIAbilityContext

  @State message: string = 'Hello World'
  permissions: Array<Permissions> = ['ohos.permission.READ_CALENDAR'];

   authType = userIAM_userAuth.UserAuthType.FACE;

  build() {
    Column() {
      CommonHeader({title:'申请权限'})
      Button('申请权限')
        .onClick(() => {
          //判断是否已经申请过权限
          PermissionUtils.checkPermissions(getContext(this) as common.UIAbilityContext,this.permissions)
        })

      // 用户拒绝授权后，有两种方式：
      // 1）跳转到应用的设置页面手动打开权限
      // 2）通过代码再次申请授权
      Button('跳转到设置打开权限-如果权限拒绝了')
        .onClick(() => {
          //跳转到设置页面
          PermissionUtils.toAppSetting(getContext(this) as common.UIAbilityContext)
        })

      Button('再次申请权限-如果权限拒绝了')
        .onClick(() => {
          //进行再次申请权限的操作
          this.againApplyPermission()
        })
    }
    .height('100%')
  }

  /**
   * 用户拒绝权限后，再次申请权限
   */
  againApplyPermission(){
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
    atManager.requestPermissionOnSetting(context, ['ohos.permission.READ_CALENDAR']).then((data: Array<abilityAccessCtrl.GrantStatus>) => {
      console.info(`requestPermissionOnSetting success, result: ${data}`);

      if(data[0] == abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED){
        promptAction.showToast({message:"成功获取到权限"})
      }else {
        promptAction.showToast({message:"获取权限失败"})
      }
    }).catch((err: BusinessError) => {
      console.error(`requestPermissionOnSetting fail, code: ${err.code}, message: ${err.message}`);
    });
  }
}