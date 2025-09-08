import { HMRouter, HMRouterMgr } from '@hadss/hmrouter'
import { CommonHeader } from '../common/common_header'
import { NavigationConstants } from '../common/constants/NavigationConstants'

@HMRouter({ pageUrl: NavigationConstants.CUSTOMANIMATORMAIN_PAGE })
@Component
export struct CustomAnimatorMainPage {
  build() {
    Column() {
      CommonHeader()
      Button('非滚动的tabs带有动画')
        .onClick(() => {
          HMRouterMgr.push({ pageUrl: NavigationConstants.CUSTOMANIMATORTABS_PAGE })
        })
      Button('滚动的tabs带有动画')
        .onClick(() => {
          HMRouterMgr.push({ pageUrl: NavigationConstants.CUSTOMANIMATORTABSWITHSCROLL_PAGE })
        })
    }
    .height('100%')
    .width('100%')
  }
}