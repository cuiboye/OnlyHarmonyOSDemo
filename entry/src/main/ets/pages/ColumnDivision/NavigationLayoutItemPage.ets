import { HMLifecycle, HMLifecycleContext, HMRouter, HMRouterMgr, IHMLifecycle } from '@hadss/hmrouter';
import { webview } from '@kit.ArkWeb';
import { CommonHeader } from '../../common/common_header';

// import { LifecycleConstants, PageRouteConstants } from 'common';

// @HMLifecycle({ lifecycleName: LifecycleConstants.NAVIGATION_LAYOUT_ITEM_PAGE_LIFECYCLE })
@HMLifecycle({ lifecycleName: "NavigationLayoutItemPageLifecycle" })
@Observed
export class NavigationLayoutItemPageLifecycle implements IHMLifecycle {
  public controller: webview.WebviewController = new webview.WebviewController();
  public bindComplete: boolean = false;

  onPrepare(ctx: HMLifecycleContext): void {
    const param = HMRouterMgr.getCurrentParam();
    if (typeof param === 'string' && this.bindComplete) {
      this.controller.loadUrl(param);
    }
  }
}

@HMRouter({
  pageUrl: "Layout://NavigationLayoutItemPage",
  singleton: true,
  // lifecycle: LifecycleConstants.NAVIGATION_LAYOUT_ITEM_PAGE_LIFECYCLE
  lifecycle: "NavigationLayoutItemPageLifecycle"
})
@Component
export struct NavigationLayoutItemPage {
  lifecycle = HMRouterMgr.getCurrentLifecycleOwner()?.getLifecycle() as NavigationLayoutItemPageLifecycle;
  h5Path?: Resource

  aboutToAppear(): void {
    this.h5Path= HMRouterMgr.getCurrentParam() as Resource;
  }
  build() {
    Column() {
      CommonHeader({title:'右侧的分栏'})
      Web({ src: this.h5Path, controller: this.lifecycle.controller })
        .domStorageAccess(true)
        .onAppear(() => {
          this.lifecycle.bindComplete = true;
        });
    }.justifyContent(FlexAlign.Center)
    .width('100%')
    // .height('100%');
  }
}