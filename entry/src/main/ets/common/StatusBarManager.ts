// import window from '@ohos.window';
// import HashMap from '@ohos.util.HashMap';
//
// /**
//  * 状态栏管理器
//  */
// export class StatusBarManager {
//   private readonly TAG = 'StatusBarManager';
//   private readonly CONFIG_SYSTEM_BAR_HEIGHT = 'systemBarHeight';
//   private static mInstance: StatusBarManager;
//   private mWindowStage: window.WindowStage;
//
//   private mConfig = new HashMap<string, any>();
//
//   private constructor() {
//   }
//
//   public static get(): StatusBarManager {
//     if (!this.mInstance) {
//       this.mInstance = new StatusBarManager();
//     }
//     return this.mInstance;
//   }
//
//   /**
//    * 存储windowStage实例
//    * @param windowStage
//    */
//   public storeWindowStage(windowStage: window.WindowStage) {
//     this.mWindowStage = windowStage;
//   }
//
//   /**
//    * 获取windowStage实例
//    * @returns
//    */
//   public getWindowStage(): window.WindowStage {
//     return this.mWindowStage;
//   }
//
//   /**
//    * 设置沉浸式状态栏
//    * @param windowStage
//    * @returns
//    */
//   public setImmersiveStatusBar(windowStage: window.WindowStage): Promise<void> {
//
//     let resolveFn, rejectFn;
//     let promise = new Promise<void>((resolve, reject) => {
//       resolveFn = resolve;
//       rejectFn = reject;
//     });
//
//     // 1.获取应用主窗口。
//     try {
//       let windowClass = windowStage.getMainWindowSync();
//       // Log.info(this.TAG, 'Succeeded in obtaining the main window. Data: ' + JSON.stringify(windowClass));
//
//       // 2.实现沉浸式效果：设置窗口可以全屏绘制。
//       // 将UI内容顶入状态栏下方
//       windowClass.setWindowLayoutFullScreen(true)
//         .then(() => {
//           //3、设置状态栏 可见
//           windowClass.setWindowSystemBarEnable(['status']).then(() => {
//             //4、设置状态栏透明背景
//             const systemBarProperties: window.SystemBarProperties = {
//               statusBarColor: '#00000000'
//             };
//             //设置窗口内导航栏、状态栏的属性
//             windowClass.setWindowSystemBarProperties(systemBarProperties)
//               .then(() => {
//                 // Log.info(this.TAG, 'Succeeded in setting the system bar properties.');
//               }).catch((err) => {
//               // Log.error(this.TAG, 'Failed to set the system bar properties. Cause: ' + JSON.stringify(err));
//             });
//           })
//
//           //5、存储状态栏高度
//           this.storeStatusBarHeight(windowClass);
//
//           resolveFn();
//         });
//
//     } catch (err) {
//       // Log.error(this.TAG, 'Failed to obtain the main window. Cause: ' + JSON.stringify(err));
//       rejectFn();
//     }
//
//     return promise;
//
//   }
//
//   /**
//    * 关闭沉浸式状态栏
//    * @param windowStage
//    * @returns
//    */
//   public hideImmersiveStatusBar(windowStage: window.WindowStage): Promise<void> {
//
//     let resolveFn, rejectFn;
//     let promise = new Promise<void>((resolve, reject) => {
//       resolveFn = resolve;
//       rejectFn = reject;
//     });
//     // 1.获取应用主窗口。
//     try {
//       let windowClass = windowStage.getMainWindowSync();
//       // Log.info(this.TAG, 'Succeeded in obtaining the main window. Data: ' + JSON.stringify(windowClass));
//
//       windowClass.setWindowLayoutFullScreen(false)
//         .then(() => {
//           //存储状态栏高度
//           this.mConfig.set(this.CONFIG_SYSTEM_BAR_HEIGHT, 0);
//           resolveFn();
//         });
//
//     } catch (err) {
//       // Log.error(this.TAG, 'Failed to obtain the main window. Cause: ' + JSON.stringify(err));
//       rejectFn(err);
//     }
//     return promise;
//
//   }
//
//
//   /**
//    * 获取状态栏高度进行保存
//    * @param windowClass
//    * @returns
//    */
//   private storeStatusBarHeight(windowClass: window.Window) {
//
//     try {
//       const avoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
//       // 保存高度信息
//       this.mConfig.set(this.CONFIG_SYSTEM_BAR_HEIGHT, avoidArea.topRect.height);
//       this.mConfig.set(this.CONFIG_SYSTEM_BAR_HEIGHT, avoidArea.topRect.height);
//       // Log.info(this.TAG, 'Succeeded in obtaining the area. Data:' + JSON.stringify(avoidArea));
//
//     } catch (err) {
//       // Log.error(this.TAG, 'Failed to obtain the area. Cause:' + JSON.stringify(err));
//     }
//   }
//
//   /**
//    * 未开启沉浸式状态栏，偏移量为0，开启， 偏移量为状态栏高度
//    * @returns
//    */
//   public getSystemBarOffset(): number {
//     let height = 0;
//     if (this.mConfig.hasKey(this.CONFIG_SYSTEM_BAR_HEIGHT)) {
//       height = this.mConfig.get(this.CONFIG_SYSTEM_BAR_HEIGHT) as number;
//     }
//     return height;
//   }
//
//   /**
//    * 是否开启沉浸式状态栏
//    * @returns
//    */
//   public isOpenImmersiveStatusBar(): boolean {
//     return this.getSystemBarOffset() > 0;
//   }
// }
//
