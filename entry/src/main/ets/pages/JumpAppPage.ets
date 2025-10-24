import { HMAnimator, HMLifecycleState, HMPopInfo, HMRouter, HMRouterMgr, IHMAnimator } from '@hadss/hmrouter';
import { CommonHeader } from '../common/common_header';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { bundleManager } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AppUtils } from '../common/AppUtils';

/**
 * 跳转和打开应用
 */
@HMRouter({ pageUrl: NavigationConstants.JUMPAPP_PAGE })
@Component
export struct JumpAppPage {

  build() {
    Column() {
      CommonHeader({title:'应用间跳转和拉起指定应用'})
      Button('是否可以打开指定的应用')
        .onClick(() => {
          this.canOpenLink()
        })
      Button('打开应用')
        .onClick(() => {
          this.openApp()
        })
    }
    .height('100%')
    .width('100%')
  }

  openApp(){
    // appLinkingOnly参数：
    // 将appLinkingOnly参数设为true，若有App Linking匹配的应用，则直接打开目标应用。若无App Linking匹配的应用，则抛异常给开发者进行处理。
    // 适用于无法打开目标应用时，开发者做了相应的异常处理。例如：拉起方应用集成了ArkWeb，当目标应用不存在时，可通过ArkWeb打开链接。
    // 将appLinkingOnly参数设为false或者不传，若有App Linking匹配的应用，则直接打开目标应用。若无App Linking匹配的应用，则尝试以浏览器打开链接的方式打开应用。
    // 适用于无法打开目标应用时，开发者未做任何处理。此时目标应用不存在时，会通过系统浏览器打开链接。
    AppUtils.getContext().openLink("app1Scheme://test.example.com/home",{appLinkingOnly:true})
    // AppUtils.getContext().openLink("http://www.baidu.com",{appLinkingOnly:false})//appLinkingOnly为false或者不传时，没有匹配的应用会尝试打开浏览器
      .then(() => {
        hilog.info(0x0000, 'testTag', `Succeeded in opening link.`);
      })
      .catch((error: BusinessError) => {
        hilog.error(0x0000, 'testTag', `Failed to open link, code: ${error.code}, message: ${error.message}`);
      })

    //需要在跳转到的应用的entry的module.json5文件的 module-abilities-skills添加如下：
    // {
    //   // actions不能为空，actions为空会造成目标方匹配失败
    //   "actions": ["ohos.want.action.home"],
    //   "uris": [
    //   {
    //     "scheme": "app1Scheme",
    //   "host": "test.example.com",
    //   "pathStartWith": "home"
    //   }
    //   ]
    // }
    //更加详细的可以参考：https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/app-linking-startup#section93961521541
  }

  //是否可以打开指定的应用
  canOpenLink(){
    try {
      let link = 'app1Scheme://test.example.com/home';//注意：entry模块的module.json5文件中配置querySchemes属性，声明想要查询的URL scheme
      let canOpen = bundleManager.canOpenLink(link);
      //没有符合条件的应用canOpen会返回false，有的话会返回true
      hilog.info(0x0000, 'testTag', 'canOpenLink successfully: %{public}s', JSON.stringify(canOpen));
    } catch (err) {
      let message = (err as BusinessError).message;
      hilog.error(0x0000, 'testTag', 'canOpenLink failed: %{public}s', message);
    }
  }
}
