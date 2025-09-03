import { AttributeUpdater } from '@kit.ArkUI';
import { HMNavigation } from '@hadss/hmrouter';
import { HMDefaultGlobalAnimator } from '@hadss/hmrouter';
import { NavigationConstants } from '../common/constants/NavigationConstants';

/**
 * 第一个页面
 */
@Entry
@Component
struct InitPage {
  modifier: NavModifier = new NavModifier();
  splashPage: string = NavigationConstants.SPLASH_PAGE

  build() {
    // @Entry中需要再套一层容器组件,Column或者Stack
    Column() {
      HMNavigation({
        navigationId: NavigationConstants.MAIN_NAVIGATION_ID,
        homePageUrl: this.splashPage,
        options: {
          dialogAnimator: HMDefaultGlobalAnimator.DIALOG_ANIMATOR,
          // standardAnimator: new IHMAnimator.Effect({
          //   direction: IHMAnimator.Direction.RIGHT_TO_LEFT,
          //   opacity: { opacity: 0.4 }
          // }),
          modifier: this.modifier
        }
      })
    }.width('100%')
    .height('100%')
  }

  onBackPress(): boolean | void {
    return true
  }
}

class NavModifier extends AttributeUpdater<NavigationAttribute> {
  initializeModifier(instance: NavigationAttribute): void {
    instance.mode(NavigationMode.Stack);
    instance.navBarWidth('100%');
    instance.hideTitleBar(true);
    instance.hideToolBar(true);
  }
}

export default InitPage



