import { TipsDialog } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { LogUtil } from '@ohos/lottie';
import { AppUtils } from '../common/AppUtils';

/**
 * 扫一扫自定义相机权限弹窗
 */
@CustomDialog
export struct CustomScanPermissionDialog {
  dialogController?: CustomDialogController;
  @Link isDialogShow: boolean;
  @State title: Resource |string = "未开启相机权限"
  @State content: Resource |string = "请在“设置”>“应用和元服务”>“百度文库”>开启“相机”权限。"

  build() {
    TipsDialog({
      title: this.title,
      content: this.content,
      primaryButton: {
        value: "取消",
        action: () => {
          this.closeDialog();
        },
      },
      secondaryButton: {
        value: "前往设置",
        action: () => {
          this.closeDialog();
          this.openPermissionsInSystemSettings();
        }
      },
    })
  }

  closeDialog(): void {
    LogUtil.info('Start to close dialog.');
    if (this.isDialogShow && this.dialogController !== undefined) {
      this.isDialogShow = false;
      this.dialogController.close();
      LogUtil.info('Succeeded in closing dialog.');
    }
  }

  openPermissionsInSystemSettings(): void {
    LogUtil.info('Start to open permissions in system settings.');
    let context = getContext(this) as common.UIAbilityContext;
    // 启动com.huawei.hmos.settings的MainAbility，并匹配application_info_entry的URI。
    let wantInfo: Want = {
      'bundleName': 'com.huawei.hmos.settings',
      'abilityName': 'com.huawei.hmos.settings.MainAbility',
      'uri': 'application_info_entry',
      'parameters': {
        'settingsParamBundleName': AppUtils.getBundleName()
      }
    };
    try {
      context.startAbility(wantInfo).then(() => {
        LogUtil.info('Succeeded in starting ability.');
      }).catch((error: BusinessError) => {
        LogUtil.info(`Failed to start ability by promise. Code: ${error.code}.`);
      })
    } catch (error) {
      LogUtil.info(`Failed to start ability by catch. Code: ${error.code}.`);
    }
  }
}
