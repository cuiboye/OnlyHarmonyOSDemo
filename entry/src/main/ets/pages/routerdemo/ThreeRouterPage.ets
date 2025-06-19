
import router from '@ohos.router'
import { CommonHeader } from '../../common/common_header';
/**
 * 第二个页面
 */
@Entry
@Component
struct ThreeRouterPage {
  @State message: string = 'Hello World'

  build() {
    Column() {
        CommonHeader({title:'第三个页面'})
        Button('返回到第一个页面').onClick(() => {
          //使用 back 可以直接回到第一个页面，并销毁中间的第二个页面
          router.back({
            url:'pages/routerdemo/first_router',
          })
        })
    }
    .height('100%')
  }
}