
import { CommonHeader } from '../common/common_header';
//通过getShared接口获取stage共享的LocalStorage实例
let storageShared: LocalStorage = LocalStorage.GetShared();

@Entry(storageShared)
@Component
struct LocalStorageSharePage2 {
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
      }
      .height('100%')
    }
}