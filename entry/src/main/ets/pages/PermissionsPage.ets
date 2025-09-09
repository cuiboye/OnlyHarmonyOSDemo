/**
 * 访问权限申请
 */
import common from '@ohos.app.ability.common';
import { CommonHeader } from '../common/common_header';
import PermissionUtils from '../common/utils/PermissionUtils';
import userIAM_userAuth from '@ohos.userIAM.userAuth';
import { Permissions } from '@ohos.abilityAccessCtrl';
import { HMRouter } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';

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
      Button('跳转到设置打开权限-如果权限拒绝了')
        .onClick(() => {
          //判断是否已经申请过权限
          PermissionUtils.openPermissionsInSystemSettings(getContext(this) as common.UIAbilityContext)
        })
    }
    .height('100%')
  }
}