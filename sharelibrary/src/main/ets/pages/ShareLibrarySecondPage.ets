/**
 * sharelibrary中的第二个页面
 */
import router from '@ohos.router'
@Entry
@Component
struct ShareLibrarySecondPage {
  @State message: string = 'Hello World-ShareLibrarySecondPage'

  build() {
    Column() {
      Text(this.message)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Button('HSP页面返回到HSP页面')
        .onClick(()=>{
          //HSP返回到HSP的页面
          //可以这样：
          // router.back({
          //   url:'@bundle:com.example.myapplication/sharelibrary/ets/pages/ShareLibraryPage'
          // })
          //也可以这样
          router.back()
        })

    }
    .height('100%')
  }
}