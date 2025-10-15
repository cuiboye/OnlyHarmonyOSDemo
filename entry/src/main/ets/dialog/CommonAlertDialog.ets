import { DialogOptions } from "../common/base/DialogOptions"

/***
 * 通用弹窗封装  title，content，单按钮，双按钮
 */
@Component
export struct CommonAlertDialog {
  options?: DialogOptions

  build() {
    Stack() {
      Column() {
        if (this.options?.title) {
          Text(this.options?.title).fontSize(16).margin({
            top: 10
          })
        }
        if (this.options?.content) {
          Text() {
            Span(this.options?.content)
          }
          .margin({
            top: 20,
            bottom: 20
          })
          .textAlign(this.options.textAlign??TextAlign.JUSTIFY)
        }

        Line().width('100%').height(0.5).backgroundColor("#e8e8e8")

        Row() {
          if (this.options?.leftBtnStr) {
            Text(this.options?.leftBtnStr)
              .onClick(() => {
                if (this.options?.leftCb) {
                  this.options?.leftCb()
                }
              }).textExtend(this.options?.leftBtnStrColor ?? '#222222')
              .borderRadius({
                bottomLeft: 10
              })
            Line().width(0.5).height('100%').backgroundColor("#e8e8e8")
          }
          Text(this.options?.rightBtnStr)
            .onClick(() => {
              if (this.options?.rightCb) {
                this.options?.rightCb()
              }
            }).textExtend(this.options?.rightBtnStrColor ?? '#1cb584')
            .borderRadius({
              bottomRight: 10
            })

        }.borderRadius(8).height(43)
      }.padding({
        top: 10
      })
      .width(300)
      .backgroundColor(Color.White).borderRadius(10)
    }.width('100%').height('300')

  }
}

@Extend(Text)
function textExtend(fontColor: ResourceStr) {
  .fontColor(fontColor)
  .height(46)
  .layoutWeight(1)
  .fontSize(16)
  .textAlign(TextAlign.Center)
}


