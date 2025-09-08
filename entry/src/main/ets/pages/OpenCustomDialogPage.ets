import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { ComponentContent, router } from '@kit.ArkUI';
import { NavigationConstants } from '../common/constants/NavigationConstants';
import { OpenCustomDialogUtils } from '../common/utils/OpenCustomDialogUtils';

class Params {
  text: string = "";

  constructor(text: string) {
    this.text = text;
  }
}


@Builder
function buildText(params: Params) {
  Column() {
    // buildText2(params.text)
    Text(params.text)
      .fontSize(50)
      .fontWeight(FontWeight.Bold)
      .margin({ bottom: 36 })
    Button('Close')
      .onClick(() => {
        OpenCustomDialogUtils.closeDialog();
      })
    // Text('aaa')
  }.backgroundColor('#FFF0F0F0')
}

@Builder
function buildText2(result: string) {
  Row(){
    Text(result)
  }
}


@HMRouter({ pageUrl: NavigationConstants.OPENCUSTOMDIALOG_PAGE })
@Component
export struct OpenCustomDialogPage {
  @State message: string = "hello";
  private ctx: UIContext = this.getUIContext();
  //buildText为自定义组件
  //注意：new Params(this.message)是作为buildText的参数，buildText这个方法的参数就是params: Params，类型需要一致；
  //如果buildText方法没有参数，可以写为：
  //private contentNode: ComponentContent<Object> = new ComponentContent(this.ctx, wrapBuilder(buildText));
  private contentNode: ComponentContent<Object> =
    new ComponentContent(this.ctx, wrapBuilder(buildText), new Params(this.message));


  aboutToAppear(): void {
    OpenCustomDialogUtils.setContext(this.ctx);
    OpenCustomDialogUtils.setContentNode(this.contentNode);
    //isModal:默认为true，有蒙层并且不可点击弹框下的UI组件；false：没有蒙层，可以与弹框下的UI组件交互
    OpenCustomDialogUtils.setOptions({ alignment: DialogAlignment.Top, offset: { dx: 0, dy: 50 },
    isModal:false});
  }


  build() {
    Row() {
      Column() {
        Button("open dialog and update options")
          .margin({ top: 50 })
          .onClick(() => {
            OpenCustomDialogUtils.openDialog(this.contentNode);


            setTimeout(() => {
              OpenCustomDialogUtils.updateDialog({
                alignment: DialogAlignment.Bottom,
                offset: { dx: 0, dy: -50 }
              });
            }, 1500)
          })
        Button("open dialog and update content")
          .margin({ top: 50 })
          .onClick(() => {
            OpenCustomDialogUtils.openDialog(this.contentNode);


            setTimeout(() => {
              this.contentNode.update(new Params('update'));
            }, 1500)
          })
        Button("阴影+进入退出的动画")
          .margin({ top: 50 })
          .onClick(() => {
            HMRouterMgr.push({ pageUrl: NavigationConstants.OPENCUSTOMDIALOGWITHANIMATOR_PAGE})
          })
        Button("api19上直接使用系统提供的dialog和背景的动画")
          .margin({ top: 50 })
          .onClick(() => {
            HMRouterMgr.push({ pageUrl: NavigationConstants.OPENCUSTOMDIALOGWITHANIMATOR_PAGE2})
          })
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
  }
}
//
//
//
// import { ComponentContent } from '@kit.ArkUI';
//
// // let duration = 1000
// // let effect: TransitionEffect =
// //   // TransitionEffect.asymmetric(
// //   //   TransitionEffect.OPACITY.animation({ duration: duration })
// //   //     .combine(
// //   //       TransitionEffect.translate({ y: 1000 }).animation({ duration: duration })
// //   //     )
// //   //   ,
// //   //   TransitionEffect.OPACITY.animation({ delay: duration, duration: duration })
// //   //     .combine(
// //   //       TransitionEffect.translate({ y: 0 }).animation({ duration: duration })
// //   //     )
// //
// //   TransitionEffect.asymmetric(
// //     TransitionEffect.translate({y:'100%'}).animation({duration:1000}),
// //     TransitionEffect.translate({y:'100%'}).animation({duration:1000})
// //   )
//
// class BaseParam {
//   context: UIContext;
//
//   constructor(context: UIContext) {
//     this.context = context;
//   }
// }
//
// class Dialog2Param extends BaseParam {
//   text: string;
//
//   constructor(context: UIContext, text: string) {
//     super(context);
//     this.text = text;
//   }
// }
//
// @Builder
// function dialog2Builder1(params: Dialog2Param) {
//   Flex({
//     direction: FlexDirection.Column,
//     alignContent: FlexAlign.Center,
//     justifyContent: FlexAlign.Center,
//     alignItems: ItemAlign.Center,
//   }) {
//     Text('dialog2')
//     Button('页面绑定dialog2关闭').onClick(() => {
//       let uiContext = params.context;
//       let promptAction = uiContext.getPromptAction();
//       promptAction.closeCustomDialog(dialog2);
//     })
//   }
//   .width('100%')
//   .height('60%')
//   .backgroundColor(Color.White)
//   .transition(effect)
//   .position({ y: 400 })
//   .mask(ProgressMask.prototype)
// }
//
// let dialog2: ComponentContent<Dialog2Param> | undefined = undefined;
//
// @Entry
// @Component
// struct OpenCustomDialogPage {
//   @State message: string = 'Hello World';
//   @State delayNumber: number = 3000
//
//   build() {
//     RelativeContainer() {
//       Button('打开dialog2').onClick(() => {
//         // let uiContext = this.getUIContext();
//         // let promptAction = uiContext.getPromptAction();
//         // dialog2 =
//         //   new ComponentContent(uiContext, wrapBuilder(dialog2Builder1), new Dialog2Param(uiContext, this.message));
//         // promptAction.openCustomDialog(dialog2,{
//         //   onWillDismiss: (action) => {
//         //     animateTo({
//         //       duration: 200,
//         //       onFinish: () => {
//         //         action.dismiss()
//         //       }
//         //     }, () => {
//         //       dialog2.update(true)
//         //     })
//         //
//         //   }
//         // });
//         // this.delayNumber = 1 / 0
//         let uiContext = this.getUIContext()
//         const promptAction = uiContext.getPromptAction()
//
//         let contentNode = new ComponentContent<boolean>(uiContext, wrapBuilder(ActionBuilder), false)
//         promptAction.openCustomDialog(contentNode, {
//           autoCancel: true,
//           alignment: DialogAlignment.Bottom,
//           transition: TransitionEffect.opacity(0.99).animation({ duration: 200 }),
//           onWillDismiss: (action) => {
//             animateTo({
//               duration: 200,
//               onFinish: () => {
//                 action.dismiss()
//               }
//             }, () => {
//               contentNode.update(true)
//             })
//
//           }
//         })
//       }).margin({top:100})
//     }
//     .height('100%')
//     .width('100%')
//   }
// }
// let duration = 1000
// let effect: TransitionEffect =
//   TransitionEffect.asymmetric(
//     TransitionEffect.OPACITY.animation({ duration: duration })
//       .combine(
//         TransitionEffect.translate({ y: 1000 }).animation({ duration: duration })
//       )
//     ,
//     TransitionEffect.OPACITY.animation({ delay: duration, duration: duration })
//       .combine(
//         TransitionEffect.translate({ y: 0 }).animation({ duration: duration })
//       )
//   )
// @Builder
// export function ActionBuilder(isEnd: boolean) {
//   Column() {
//     Row() {
//       Text('2173781637163')
//     }.width('100%')
//     .height(40)
//
//     Row() {
//       Text('2173781637163')
//     }.width('100%')
//     .height(59)
//
//     Row() {
//       Text('2173781637163')
//     }.width('100%')
//     .height(90)
//   }
//   .translate({
//     y: isEnd ? '100%' : 0
//   })
//   .backgroundColor(Color.White)
//   .transition(TransitionEffect.translate({ y: '100%' }).animation({ duration: 200 }))
// }