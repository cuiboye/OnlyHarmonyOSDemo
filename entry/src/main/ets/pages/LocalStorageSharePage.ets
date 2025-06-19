/**
 * LocalStorage的使用
 */
import router from '@ohos.router';
import { CommonHeader } from '../common/common_header';
//通过getShared接口获取stage共享的LocalStorage实例
let storageShared: LocalStorage = LocalStorage.GetShared();

@Entry(storageShared)
@Component
export default struct LocalStorageSharePage {
  @LocalStorageLink('localStorageShare') result: number = 1

  build() {
    Column() {
      CommonHeader()
      Row(){
        Text(`value is ${this.result}`)
        Button('改变值')
          .onClick(() => {
            this.result += 1
          })
      }
      Button('跳转到下一个页面')
        .onClick(() => {
          router.pushUrl({url:'pages/LocalStorageSharePage2'})
        })
    }
    .height('100%')
  }
}