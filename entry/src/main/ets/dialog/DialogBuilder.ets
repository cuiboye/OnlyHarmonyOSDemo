import { DialogOptions } from "../common/base/DialogOptions";
import { CommonAlertDialog } from "./CommonAlertDialog";

// 双button 对话框
@Builder
export function commonAlertDialog(options: DialogOptions) {
  CommonAlertDialog({ options: options })
}