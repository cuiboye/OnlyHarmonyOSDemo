import { RenameCustomDialogView } from '../views/RenameCustomDialogView'
import { LengthMetrics, promptAction } from '@kit.ArkUI'
import { CommonHeader } from '../common/common_header'

/**
 * @CustomDialog包含输入框
 */
@Entry
@Component
struct RenameCustomDialog {
  //输入框默认内容
  @State initInputContent: ResourceStr = '新建文件夹'
  folderDialogController: CustomDialogController | null = new CustomDialogController({
    builder: RenameCustomDialogView({
      cancel: this.onNewFolderCancel,
      // confirm:this.onNewFolderConfirm.bind(this),//不推荐使用bind绑定this
      confirm: (fileName: string) => { //推荐使用 => 这种方式 绑定 this
        this.onNewFolderConfirm(fileName)
      },
      initContent: this.initInputContent,
    }),
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    offset: { dy: 0, dx: 0 },
    autoCancel: true,
    keyboardAvoidMode: KeyboardAvoidMode.DEFAULT, // 软键盘弹出时，弹出框自动避让
    keyboardAvoidDistance: LengthMetrics.vp(0) // 软键盘弹出时与弹出框的距离为0vp
  })

  //取消
  onNewFolderCancel() {

  }

  //确定
  onNewFolderConfirm(inputValue: string) {
    promptAction.showToast({ message: inputValue })
  }

  build() {
    Column() {
      CommonHeader({ title: ' @CustomDialog包含输入框' })
      Button('弹框Dialog')
        .onClick(() => {
          this.folderDialogController?.open()
        })
    }
    .height('100%')
    .width('100%')
  }
}