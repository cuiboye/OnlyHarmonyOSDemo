import { ComponentContent } from '@kit.ArkUI';
import { PromptActionClass } from '../widget/PromptActionClass';

class Params {
  text: string = "";

  constructor(text: string) {
    this.text = text;
  }
}


@Builder
function buildText(params: Params) {
  Column() {
    buildText2(params.text)
    // Text(params.text)
    //   .fontSize(50)
    //   .fontWeight(FontWeight.Bold)
      // .margin({ bottom: 36 })
    Button('Close')
      .onClick(() => {
        PromptActionClass.closeDialog();
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


@Entry
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
    PromptActionClass.setContext(this.ctx);
    PromptActionClass.setContentNode(this.contentNode);
    //isModal:默认为true，有蒙层并且不可点击弹框下的UI组件；false：没有蒙层，可以与弹框下的UI组件交互
    PromptActionClass.setOptions({ alignment: DialogAlignment.Top, offset: { dx: 0, dy: 50 },
    isModal:false});
  }


  build() {
    Row() {
      Column() {
        Button("open dialog and update options")
          .margin({ top: 50 })
          .onClick(() => {
            PromptActionClass.openDialog();


            setTimeout(() => {
              PromptActionClass.updateDialog({
                alignment: DialogAlignment.Bottom,
                offset: { dx: 0, dy: -50 }
              });
            }, 1500)
          })
        Button("open dialog and update content")
          .margin({ top: 50 })
          .onClick(() => {
            PromptActionClass.openDialog();


            setTimeout(() => {
              this.contentNode.update(new Params('update'));
            }, 1500)
          })
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
  }
}