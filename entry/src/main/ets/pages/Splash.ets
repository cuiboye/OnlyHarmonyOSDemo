import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import window from '@ohos.window';
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';

/**
 * 闪屏页面
 * 注意：闪屏页启动的时候会有白屏问题，暂时无法解决
 */
@HMRouter({ pageUrl: NavigationConstants.SPLASH_PAGE })
@Component
export struct Splash {
  private swiperController: SwiperController = new SwiperController();
  private data: Resource[] = [];
  @State showSwiper: boolean = false;
  private timer:number = -1;
  @StorageProp('navigationHeight') navigationHeight: number = 0
  private context = getContext(this) as common.UIAbilityContext

  onPageShow(){
    //闪屏页不需要顶部和底部的安全区域
    window.getLastWindow(this.context).then((windowClass) => {
      windowClass.setWindowSystemBarEnable([]).then(() => {
      })
    })
  }

  aboutToAppear(): void {
    setTimeout(() => {
      this.gotoMainPage();
    }, 3000);
  }

  gotoMainPage() {
    // router.replaceUrl(
    //   {
    //     url: 'pages/Index',
    //   },
    // )
    //替换掉当前页面
    HMRouterMgr.replace({ pageUrl: NavigationConstants.INDEX_PAGE})
  }

  clearTiming() {
    if (this.timer !== -1) {
      clearInterval(this.timer);
      this.timer = -1;
    }
  }

  aboutToDisappear() {
    this.clearTiming();
  }

  build() {
    Column() {
      Image($r('app.media.launch_new'))
        .width('100%')
        .layoutWeight(1)
      Text('底部')
    }
    .height('100%')
    .padding({bottom:px2vp(this.navigationHeight)})
  }
}