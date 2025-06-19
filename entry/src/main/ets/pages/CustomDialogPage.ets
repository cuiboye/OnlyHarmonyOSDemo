//  * 自定义弹框
//  */
import prompt from '@ohos.prompt'
import { CommonHeader } from '../common/common_header'
@Entry
@Component
export  struct CustomDialogPage {
  @State buttonPosition:number = 0

  //dialogController定义的时候需要包含null,否则销毁的时候无法置为null
  dialogController:CustomDialogController | null = new CustomDialogController({
    builder:DialogView({
      cancel:this.onCancel,
      confirm:this.onConfirm
    }),
    alignment:DialogAlignment.Top, //Dialog的对齐方式
    // 弹窗容器样式是否自定义。
    // 默认值：false，弹窗容器的宽度根据栅格系统自适应，不跟随子节点；高度自适应子节点，最大为窗口
    // 高度的90%；圆角为24vp。
    customStyle:true,
    //注意:使用@State之类的状态管理是不能刷新CustomDialogController中的属性
    offset:{dy:this.buttonPosition,dx:0},//x和y轴的偏移量
    autoCancel:false//点击外部是否使弹框消失
  })

  aboutToDisappear(){
    //销毁的时候将CustomDialogController设置为null
    this.dialogController = null
  }

  onCancel(){
    prompt.showToast({message:'取消'})
  }

  onConfirm(){
    prompt.showToast({message:'确定'})
  }

  build() {
    Column() {
      CommonHeader()

     Button('自定义弹框')
       .id('button')
       .onClick(()=>{
        this.dialogController?.open()//打开弹框
       })
      Text('CenterText').layoutWeight(1)
    }
    .height('100%')
  }

}

//通过 @CustomDialog来定义一个弹框
@CustomDialog
struct DialogView{
  customControllerTwo:CustomDialogController = new CustomDialogController({
    builder:SecondDialogView({
      //这里需要使用 bind(this)将方法绑定到DialogView中，不然onSecondCancel回调的将是SecondDialogView中的onSecondCancel方法，
      //而SecondDialogView中是没有onSecondCancel这个方法的，所以不加 bind(this)的话会报错
      onSecondCancel:this.onSecondCancel.bind(this),
      onSecondConfirm:this.onSecondConfirm.bind(this)
    }),
    alignment:DialogAlignment.Top
  })
  // 若尝试在CustomDialog中传入多个其他的Controller，以实现在CustomDialog中打开另一个或另一些CustomDialog，那么此处需要将指向自己的controller放在所有controller的后面
  controller:CustomDialogController
  cancel?:()=>void
  confirm?:()=>void
  onSecondCancel(){
    prompt.showToast({message:'第二个取消'})
  }

  onSecondConfirm(){
    // prompt.showToast({message:'第二个确定'})
    this.controller.close()
    this.confirm?.()
  }

  build(){
    Column(){
      Button('打开第二个Dialog')
      .onClick(()=>{
        this.customControllerTwo.open()
      })
      Row(){
        Button('取消')
          .onClick(()=>{
            if(this.controller!=undefined){
              this.controller.close()//关闭弹框
              this.cancel?.()
            }
          })
        Button('确认')
          .onClick(()=>{
            if(this.controller!=undefined){
              this.controller.close()
              this.confirm?.()
            }
          })
      }
    }
    .width('100%')
    .backgroundColor(Color.White)
  }
}

@CustomDialog
struct SecondDialogView{
  controller:CustomDialogController
  onSecondCancel?:()=>void
  onSecondConfirm?:()=>void

  build(){
    Column(){
      Button('确认')
        .onClick(()=>{
          if(this.controller != undefined){
            this.controller.close()
            this.onSecondConfirm?.()
          }
        })
    }
    .width('100%')
    .backgroundColor(Color.White)
  }
}
