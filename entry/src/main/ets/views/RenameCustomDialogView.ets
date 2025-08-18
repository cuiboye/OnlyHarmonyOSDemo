import { promptAction } from "@kit.ArkUI"
import { AnimationUtil } from "../common/utils/AnimationUtil"

/**
 * @CustomDialog中包含输入框
 */
@CustomDialog
export struct RenameCustomDialogView {
  @StorageProp('navigationHeight') navigationHeight: number = 0
  cancel?: () => void
  confirm?: (fileName:string) => void
  controller: CustomDialogController
  initTitle: ResourceStr = '我是标题'
  @Prop initContent:  ResourceStr = '我是默认的内容'
  @State inputValue: ResourceStr = '我是默认的内容'
  private inputController: TextInputController = new TextInputController()
  @State text: string = ''
  @State showDeleteBtn: boolean = true
  @State showFlag: Visibility = Visibility.Visible;
  @State isAutoCancel: boolean = true;

  aboutToAppear(): void {
    this.inputValue = this.initContent
  }

  build() {
    Column() {
      Column() {
        Row() {
          Text('取消')
            .onClick(() => {
              if (this.controller != undefined) {
                // this.controller.close()
                // this.cancel?.()
                this.clickOuterCancel()//用这个才会有动画
              }
            })
            .fontSize(13)
            .fontColor('#060606')
            .padding({
              left: 13,
              right: 13,
              top: 20,
              bottom: 20
            })
          Text('创建文件夹')
            .fontSize(15)
            .fontColor('#060606')
          Text('完成')
            .onClick(() => {
              if (this.controller != undefined) {
                if ((this.inputValue.toString() ?? '').trim() === '') {
                  promptAction.showToast({message:'请输入文件夹名称'})
                  return
                }
                // this.controller.close()
                this.clickOuterCancel()//用这个才会有动画
                this.confirm?.(this.inputValue.toString() ?? '')
              }
            })
            .fontSize(13)
            .fontColor('#4fac72')
            .fontWeight(FontWeight.Bold)
            .padding({
              left: 13,
              right: 13,
              top: 20,
              bottom: 20
            })
        }
        .borderRadius({
          topLeft: 15,
          topRight: 15
        })
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .backgroundColor(Color.White)

        Row() {
          Stack() {
            Image($r('app.media.app_home_tabbar_seach'))
              .height(30)
          }
          .alignSelf(ItemAlign.End)
          .margin({ left: 13, right: 13 })

          Column() {
            Row().height(1).width('100%').backgroundColor(Color.White)
            Row() {
              TextInput({
                placeholder: '',
                text: this.inputValue,
                controller: this.inputController
              })
                .fontSize(15)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1d2424')
                .padding({ left: 5 })
                .onFocus(() => {
                  this.inputController.setTextSelection(0, this.inputValue.toString().length??0)
                })
                .onChange((value: string) => {
                  this.inputValue = value
                  if(this.inputValue){
                    this.showDeleteBtn = true
                  }else {
                    this.showDeleteBtn = false
                  }
                })
                .defaultFocus(true)
                .layoutWeight(1)
                .backgroundColor(Color.White)
              // Stack() {
              //   Image($r('app.media.')).width(20)
              // }
              Button('清空')
                .onClick(() => {
                  this.inputValue = ''
                  this.showDeleteBtn = false
                })
              .visibility(this.showDeleteBtn ? Visibility.Visible : Visibility.None)
              .padding({ left: 13, right: 13 })
            }

            Row().height(1).width('100%').backgroundColor('#08000000').margin({ right: 20 })
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .layoutWeight(1)
        }
        .width('100%')
        .backgroundColor(Color.White)
        .padding({ top: 15 })
      }
      .width('100%')

      Row()
        .height(px2vp(this.navigationHeight))
        .backgroundColor(Color.White)
        .width('100%')
    }
    .justifyContent(FlexAlign.End)
    .onClick(() => {
      if (this.isAutoCancel) {
        this.clickOuterCancel();//高度需要设置为100%，this.clickOuterCancel()这个方法才会执行
      }
    })
    .visibility(this.showFlag)
    // 定义进场出场转场动画效果
    // .transition(AnimationUtil.transitionFromDown(1000))//如果需要设置dialog动画的时间的话那就设置这个
    .transition(AnimationUtil.transitionFromDown(500))
    .width('100%')
    .height('100%')

  }

  // 延迟关闭弹窗，让自定义的出场动画显示
  clickOuterCancel() {
    this.showFlag = Visibility.Hidden
    setTimeout(() => {
      this.controller.close()
    }, 200) //这个时间是背景色的展示和消失的时间
  }
}