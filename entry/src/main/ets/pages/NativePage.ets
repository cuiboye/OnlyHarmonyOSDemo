import { router } from '@kit.ArkUI';

@Entry
@Component
struct NativePage {
  @State message: string = 'ArkUI';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('返回')
          .onClick(()=>{
            router.back()
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}