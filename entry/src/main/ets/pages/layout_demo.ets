/**
 * 布局学习
 */
@Entry
@Component
struct LayoutDemo {
  @State message: string = 'Hello World'

  build() {
    //1）space:每个元素之间的间距
    //2）width和height:宽高
    //3）backgroundColor：背景色
    //4）容器的根结点需要设置为100%，否则不会显示
    //5）Row和Column的交叉轴如果是充满布局，那么元素在交叉轴上面对齐方式为居中对齐
    //如果是Column可以通过设置alignItems属性为HorizontalAlign.Start来改变交叉轴上元素的位置。
    //6）alignItems：可以通过alignItems属性设置子元素在交叉轴（排列方向的垂直方向）上的对齐方式
    //7）alignSelf属性用于控制单个子元素在容器交叉轴上的对齐方式，其优先级高于alignItems属性，如果设置了alignSelf属性，则在单个子元素上会覆盖alignItems属性。
    //8）justifyContent：设置主轴上的对齐方式
    //9）layoutWeight：使子元素占满剩余空间
    Scroll() {
      Column() {
        // Column({space:20}) {
        //   Text(this.message)
        //     .fontSize(12)
        //     .fontWeight(FontWeight.Bold)
        //     .fontColor(Color.Black)
        // }.width('100%').backgroundColor(Color.Red).margin({top:10}).padding({left:10})
        Text('1.Row和Column布局')
        Column() {
          Text(this.message)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Black)
          Text(this.message)
            .fontSize(12)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Black).alignSelf(ItemAlign.Center) //通过alignSelf设置子元素水平居中
        }
        .backgroundColor(Color.Gray)
        .width('100%')
        .height(80)
        .alignItems(HorizontalAlign.Start) //alignItems：设置交叉轴方向上元素对齐方式左对齐
        .justifyContent(FlexAlign.End) //justifyContent：设置主轴上的对齐方式

        Row() {
          Text('测试layoutWeight').layoutWeight(1) //layoutWeight:占满可用的剩余空间
          Text('hello').backgroundColor(Color.Red).fontSize(8)
        }.width('100%').backgroundColor(Color.Gray).margin({ top: 10 }).padding({ left: 10 })

        Text('2.Stack布局')
        //Stack中的子元素默认是居中的
        Stack({ alignContent: Alignment.Bottom }) {
          Row().height(200).width(200).backgroundColor(Color.Blue)
          Row().height(100).width(100).backgroundColor(Color.Red)
          Row().height(50).width(50).backgroundColor(Color.Gray)
        }.width('100%')

        Text('3.Flex布局')
        Flex() {
          Text('多少发多少了空间多少发多少了空间多少发多少了空间多少发多少了空间多少发多少了空间')
          Text('结尾')
        }.width('100%')

        Text('4.RelativeContainer相对布局')

        //1）RelativeContainer父组件为锚点，__container__代表父容器的id；其余子元素的ID通过id属性设置。未设置ID的子元素在RelativeContainer中不会显示。
        //2）必须为RelativeContainer及其子元素设置ID，用于指定锚点信息。
        RelativeContainer() {
          //定义在父布局的左上角
          Row()
            .width(50)
            .height(50)
            .backgroundColor(Color.Red)
            .alignRules({
              top: { anchor: '__container__', align: VerticalAlign.Top },
              left: { anchor: '__container__', align: HorizontalAlign.Start }
            })
            .id('Row1')

          Row()
            .width(50)
            .height(50)
            .backgroundColor(Color.Blue)
              //定位在父布局的右上角
            .alignRules({
              top: { anchor: '__container__', align: VerticalAlign.Top },
              right: { anchor: '__container__', align: HorizontalAlign.End }
            })
            .id('Row2')

          //以子元素为参照物
          Text('我在下面')
            .id('Text')
            .alignRules({ top: { anchor: 'Row2', align: VerticalAlign.Bottom } })
        }.width('100%').height(200).backgroundColor(Color.Gray)

        //
        Text('4.RelativeContainer设置相对于锚点的对齐位置')
        RelativeContainer() {
          Row()
            .alignRules({
              //top:以父布局为参照物，顶部挨着父布局的顶部
              //middle：以父布局为参照物，水平居中
              top: { anchor: '__container__', align: VerticalAlign.Top },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
            .width(100)
            .height(100)
            .backgroundColor(Color.Red)
            .id('Row')
          Row()
            .alignRules({
              //top:以Row1为参照物，顶部挨着Row1的底部
              //middle：以父布局为参照物，水平居中
              top: { anchor: 'Row', align: VerticalAlign.Bottom },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
            .width(100)
            .height(100)
            .backgroundColor(Color.Blue)
            .id('CenterRow')
          Row()
            .alignRules({
              top: { anchor: 'Row', align: VerticalAlign.Bottom },
              right: { anchor: 'CenterRow', align: HorizontalAlign.Start }
            })
            .width(100)
            .height(100)
            .backgroundColor(Color.Black)
            .id('LeftCenterRow')
          Row()
            .alignRules({
              top: { anchor: 'Row', align: VerticalAlign.Bottom },
              right: { anchor: '__container__', align: HorizontalAlign.End }
            })
            .width(100)
            .height(100)
            .backgroundColor(Color.Orange)
            .id('RightCenterRow')
          Row()
            .alignRules({
              bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
            .width(100)
            .height(100)
            .backgroundColor(Color.Yellow)
            .id('BottomCenterRow')
        }.height(300).width(300).backgroundColor(Color.Gray)
      }.height('100%').width('100%').margin({ top: 50 })
    }
  }
}