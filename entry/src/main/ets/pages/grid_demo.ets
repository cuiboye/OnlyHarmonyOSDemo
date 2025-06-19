@Entry
@Component
struct GridDemo {
  @State message: string = 'Hello World'

  build() {
    Column() {
      Grid() {
        ForEach([1,2,3,4,,5,6,7,8,9,10], (item: number) => {
          GridItem() {
            Column(){
              Text('好酒')
                .fontColor('#989898')
                .fontSize(14)
                .height(400)
                .margin({top:8})
              Text('好酒2')
                .fontColor('#989898')
                .fontSize(14)
                .margin({top:8})
            }
          }
        })
      }
      .constraintSize({minHeight: 100})
      // .flexGrow(1)
      // .rowsTemplate('1fr 1fr 1fr 1fr 1fr') //设置Grid为5行
      .columnsTemplate('1fr 1fr') //设置Grid为2列
    }
    .height('100%')
  }
}