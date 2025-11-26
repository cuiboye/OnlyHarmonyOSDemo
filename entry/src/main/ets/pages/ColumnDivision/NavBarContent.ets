import { HMLifecycleState, HMRouterMgr } from '@hadss/hmrouter';

export interface NavBarMenu {
  title: string;
  url: string | Resource;
}

@Component
export struct NavBarContent {
  @BuilderParam navBarDesc: () => void = this.navBarDescDefault;
  private data: NavBarMenu[] = [{
    title: 'HMRouter的路由方案',
    url: $r('app.string.h5_url_1'),
  }, {
    title: '性能优化工具使用案例1',
    url: $r('app.string.h5_url_2')
  }, {
    title: '性能优化工具使用案例2',
    url: $r('app.string.h5_url_3')
  }, {
    title: '性能优化工具使用案例3',
    url: $r('app.string.h5_url_4')
  }, {
    title: '性能优化工具使用案例4',
    url: $r('app.string.h5_url_5')
  }];
  private reConfirm: boolean = false;
  private hideTitle: boolean = false;

  @Builder
  navBarDescDefault() {
  }

  aboutToAppear(): void {
    const owner = HMRouterMgr.getCurrentLifecycleOwner();
    // Intercept the navbar page exit scenario
    owner?.addObserver(HMLifecycleState.onBackPressed, (ctx) => {
      if (this.reConfirm === false) {
        this.reConfirm = true;
        setTimeout(() => {
          this.reConfirm = false;
        }, 1500);
        ctx.uiContext.getPromptAction().showToast({
          message: '再次返回退出页面',
          duration: 1500
        });
        return true;
      } else {
        return false;
      }
    });
  }

  build() {
    Column() {
      this.navBarDesc?.();
      if (!this.hideTitle) {
        Text($r('app.string.layout_case1_title'))
          .textAlign(TextAlign.Start)
          .margin({
            bottom: 12,
            left: 26
          })
          .fontSize(18)
          .fontWeight(FontWeight.Bold);
      }

      List({ space: 8 }) {
        ForEach(this.data, (item: NavBarMenu) => {
          ListItem() {
            Row() {
              Text(item.title)
                .fontSize(16)
                .fontColor('#333333')
                .textAlign(TextAlign.Start)
                .layoutWeight(1);
              Image($r('app.media.home_main_right_arrow'))
                .width(12)
                .height(24);

            }
            .width('100%')
            .height(48)
            .borderRadius(16)
            .padding(12)
            .backgroundColor('#FFFFFF');
          }
          .padding({
            left: 14,
            right: 14
          })
          .onClick(() => {
            //Demo中使用的是pushAsync这种方式跳转的，首次跳转是没有问题的，再次跳转的话不会打开新的页面
            // HMRouterMgr.pushAsync({
            //   pageUrl: "Layout://NavigationLayoutItemPage",
            //   param: item.url
            // });
            //下面这种方式是没有问题的
            HMRouterMgr.replace({
              pageUrl: "Layout://NavigationLayoutItemPage",
              param: item.url,
              animator: false
            })
          });
        }, (item: NavBarMenu, index: number) => index.toString());
      }.height('auto')
      .width('100%');
    }.justifyContent(FlexAlign.Start)
    .padding({ top: 20 })
    .alignItems(HorizontalAlign.Start);
  }
}