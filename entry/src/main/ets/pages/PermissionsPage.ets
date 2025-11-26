/**
 * 访问权限申请
 */
import common from '@ohos.app.ability.common';
import { CommonHeader } from '../common/common_header';
import PermissionUtils from '../common/utils/PermissionUtils';
import userIAM_userAuth from '@ohos.userIAM.userAuth';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import { HMLifecycleState, HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { BusinessError } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import preferencesUtil from '../common/utils/PreferencesUtil';
import { CustomScanPermissionDialog } from '../views/CustomScanPermissionDialog';
import { LogUtil } from '@ohos/lottie';

@HMRouter({ pageUrl: NavigationConstants.PERMISSIONS_PAGE })
@Component
export struct PermissionsPage {
  private context = getContext(this) as common.UIAbilityContext
  @State message: string = 'Hello World'
  permissions: Array<Permissions> = ['ohos.permission.READ_CALENDAR'];
  authType = userIAM_userAuth.UserAuthType.FACE;
  @State isDialogShow: boolean = false
  isDialogShowFirst: boolean = false //第一次进入弹框

  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomScanPermissionDialog({
      isDialogShow: this.isDialogShow,
      title: "某某APP将使用“摄像头”",
      content: "为了正常使用说图解画、图片配文等功能，请允许APP使用摄像头。您可以通过系统“设置”进行权限管理"
    }),
    autoCancel: false,
    customStyle: false,
    alignment: DialogAlignment.Center
  })

  aboutToAppear(): void {
    HMRouterMgr.getCurrentLifecycleOwner()?.addObserver(HMLifecycleState.onShown, () => {
      this.initPermission()
    })
    HMRouterMgr.getCurrentLifecycleOwner()?.addObserver(HMLifecycleState.onHidden, () => {
      LogUtil.info('HMLifecycleState.onHidden')
    })
  }

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

      Button('通过代码再次申请权限-如果权限拒绝了')
        .onClick(() => {
          //进行再次申请权限的操作
          this.againApplyPermission()
        })

      Button('判断有没有权限以及跳转到设置中打开权限回到app刷新页面')
        .onClick(async () => {
          this.initPermission()
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

  async initPermission(){
    let enableCameraPermission = PermissionUtils.checkPermissionEnable("ohos.permission.CAMERA")
    if (enableCameraPermission) {
      promptAction.showToast({message:'有权限了！'})
      //有权限
    } else {
      let refuse = await preferencesUtil.getPreferenceValue('MyPreferences', 'PERMISSIONS_REFUSE', false)
      if (refuse) { //之前点击了不允许或者手动在设置中关闭了权限
        //这里可以跳转到应用的详情中手动打开权限
        if(!this.isDialogShow  && !this.isDialogShowFirst){
          this.dialogController.open()
          this.isDialogShow = true
          this.isDialogShowFirst = true
        }
      } else {
        const permissions: Array<Permissions> = ['ohos.permission.CAMERA']
        PermissionUtils.reqPermissionsFromUser(permissions, {
          refuseAuthorization: async () => {
            //点击了“不允许”权限
            await preferencesUtil.putPreferenceValue('MyPreferences', 'PERMISSIONS_REFUSE', true)
            //这里可以跳转到应用的详情中手动打开权限
            if(!this.isDialogShow && !this.isDialogShowFirst){//这里加这个判断的原因是这个refuseAuthorization回调方法会执行两次
              this.dialogController.open()
              this.isDialogShow = true
              this.isDialogShowFirst = true
            }
            LogUtil.info('点击了“不允许”权限')
          },
          successAuthorization: async () => {
            //点击了“允许”权限
            setTimeout(() => {
              //处理允许权限后的逻辑处理
              // promptAction.showToast({message:'点击了允许'})
            }, 300)

            //注意：这个方法中可以不处理任何的事情，后面发现，监听到有权限了，这里不用处理任何逻辑，会重新执行initPermission这个方法，因为dialog出现的时候会执行页面的HMRouter的HMLifecycleState.onHidden方法
            //dialog消失的时候会执行HMRouter的HMLifecycleState.onShown
          }
        })
      }
    }
  }
}