@Entry
@Component
struct Index {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Text($r('app.string.shared_desc'))
      }
      .width('100%')
    }
    .height('100%')
  }
}