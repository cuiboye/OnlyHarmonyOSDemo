import { router } from '@kit.ArkUI'
import { CommonHeader } from '../common/common_header'

@Entry
@Component
struct CustomAnimatorMainPage {
  build() {
    Column() {
      CommonHeader()
      Button('非滚动的tabs带有动画')
        .onClick(()=>{
          router.pushUrl(
            {
              url: "pages/CustomAnimatorTabsPage",
            },
          )
        })
      Button('滚动的tabs带有动画')
        .onClick(()=>{
          router.pushUrl(
            {
              url: "pages/CustomAnimatorTabsWithScrollPage",
            },
          )
        })
    }
    .height('100%')
    .width('100%')
  }
}