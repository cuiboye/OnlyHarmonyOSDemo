import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { WXCallbackInterface, WXEventHandler } from '../utils/WXCallbackInterface';
import { wxApi } from '../utils/WxShareViewModel';
import { QQShareInstance } from '../utils/QQShareInstance';
import { WeiboShareInstance } from '../utils/WeiboShareInstance';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');

    //挂载微信分享回调，必须要有下面这两句
    WXCallbackInterface.WXCallbackCreate()
    this.handleWeChatCallIfNeed(want)

    //QQ
    QQShareInstance.create()

    //微博分享回调
    WeiboShareInstance.initSdk(this.context)
    WeiboShareInstance.mWBAPI!.doWBAsResult(want, this.context)
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.handleWeChatCallIfNeed(want)
    //微博分享回调
    WeiboShareInstance.mWBAPI!.doWBAsResult(want, this.context)
  }

  //微信回调
  private handleWeChatCallIfNeed(want: Want) {
    wxApi.handleWant(want, WXEventHandler)
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}