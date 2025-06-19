import router from '@ohos.router'
@Entry
@Component
struct ShareLibraryPage {
  @State message: string = 'Hello World-ShareLibraryPage'

  build() {
    Column() {
      Text(this.message)
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Button('返回到HAP页面')
        .onClick(()=>{
          router.back({
            url:'pages/Index'//路径为：`entry/src/main/ets/pages/Index.ets`
          })
        })

      Button('HSP页面跳转到HSP页面')
        .onClick(()=>{
          //HSP跳转HSP的页面
          // router.pushUrl({
          //   url:'@bundle:com.example.myapplication/sharelibrary/ets/pages/ShareLibrarySecondPage'
          // })
        })
    }
    .height('100%')
  }
}