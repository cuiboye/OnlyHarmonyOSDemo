import bundleManager from '@ohos.bundle.bundleManager';
import { BusinessError } from '@ohos.base';
import { KeyboardAvoidMode, window } from '@kit.ArkUI';
import { resourceManager } from '@kit.LocalizationKit';
import { common, Want } from '@kit.AbilityKit';
import { HMRouterMgr } from '@hadss/hmrouter';
import { ApplicationContext } from './ApplicationContext';
import { NavigationConstants } from './constants/NavigationConstants';


export class AppUtils {

  private constructor() {
  }

  private static context: common.UIAbilityContext
  // 应用设置页面
  private static readonly uri_info: string = 'application_info_entry'

  /**
   * 获取上下文
   */
  static getContext(): common.UIAbilityContext {
    if (!AppUtils.context) {
      AppUtils.context = ApplicationContext.getContext();
      console.log("context为空，请在UIAbility的onWindowStageCreate方法中调用AppUtil的init方法初始化！");
    }
    return AppUtils.context;
  }

  /**
   * 获取UIContext
   */
  static getUIContext(): UIContext {
    return AppUtils.getMainWindow().getUIContext();
  }

  /**
   * 获取WindowStage
   */
  static getWindowStage(): window.WindowStage {
    return AppUtils.getContext().windowStage;
  }

  /**
   * 获取主窗口
   */
  static getMainWindow(): window.Window {
    return AppUtils.getContext().windowStage.getMainWindowSync();
  }


  /**
   * 设置灰阶，APP一键置灰。
   * @param grayScale  该参数为浮点数，取值范围为[0.0, 1.0]。
   * @param onlyMainWindow 是否只置灰主窗口，默认false。
   */
  static async setGrayScale(grayScale: number = 1.0, onlyMainWindow: boolean = false): Promise<void> {
    AppUtils.getMainWindow().setWindowGrayScale(grayScale);
    if (!onlyMainWindow) {
      let subWindows = await AppUtils.getContext().windowStage.getSubWindow();
      if (subWindows && subWindows.length > 0) {
        subWindows.forEach((subWindow) => subWindow.setWindowGrayScale(grayScale));
      }
    }
  }


  /**
   * 获取当前窗口的属性
   * @param windowClass 不传该值，获取主窗口的属性
   */
  static getWindowProperties(windowClass?: window.Window): window.WindowProperties {
    if (!windowClass) {
      windowClass = AppUtils.getMainWindow()
    }
    return windowClass.getWindowProperties();
  }


  /**
   * 获取虚拟键盘抬起时的页面避让模式（OFFSET-上抬模式、RESIZE-压缩模式）。
   */
  static getKeyboardAvoidMode(): KeyboardAvoidMode {
    let mode = AppUtils.getUIContext().getKeyboardAvoidMode();
    if (typeof mode === 'string') {
      if ('KeyBoardAvoidMode.RESIZE' === mode) {
        return KeyboardAvoidMode.RESIZE;
      } else {
        return KeyboardAvoidMode.OFFSET;
      }
    }
    return mode;
  }


  /**
   * 设置虚拟键盘弹出时，页面的避让模式。
   * @param value （OFFSET-上抬模式、RESIZE-压缩模式）
   */
  static setKeyboardAvoidMode(value: KeyboardAvoidMode): boolean {
    try {
      AppUtils.getUIContext().setKeyboardAvoidMode(value);
    } catch (err) {
      return false;
    }
    return true;
  }

  /**
   * 获取提供访问应用资源的能力
   */
  static getResManager(): resourceManager.ResourceManager {
    return AppUtils.getContext().resourceManager;
  }

  /**
   * 获取设备的Configuration
   */
  static getConfigurationSync(): resourceManager.Configuration {
    return AppUtils.getResManager().getConfigurationSync();
  }

  /**
   * 获取当前设备屏幕方向。
   */
  static getDirection(): Number {
    return AppUtils.getConfigurationSync().direction
  }

  /**
   * 设备是否竖屏
   */
  static isPortrait(): Boolean {
    let direction = AppUtils.getDirection();
    return direction == resourceManager.Direction.DIRECTION_VERTICAL;
  }

  /**
   * 设置屏幕是否为常亮状态
   */
  static async setWindowKeepScreenOn(isKeepScreenOn: boolean, windowClass?: window.Window): Promise<void> {
    try {
      if (!windowClass) {
        windowClass = AppUtils.getMainWindow();
      }
      return windowClass.setWindowKeepScreenOn(isKeepScreenOn);
    } catch (err) {
      console.log(JSON.stringify(err))
      return;
    }
  }


  /**
   * 设置窗口是否为隐私模式。设置为隐私模式的窗口，窗口内容将无法被截屏或录屏。
   */
  static async setWindowPrivacyMode(isPrivacyMode: boolean, windowClass?: window.Window): Promise<void> {
    try {
      if (!windowClass) {
        windowClass = AppUtils.getMainWindow();
      }
      return windowClass.setWindowPrivacyMode(isPrivacyMode);
    } catch (err) {
      console.log(JSON.stringify(err));
      return;
    }
  }


  /**
   * 设置窗口的背景色
   */
  static async setWindowBackgroundColor(color: string, windowClass?: window.Window) {
    try {
      if (!windowClass) {
        windowClass = AppUtils.getMainWindow();
      }
      return windowClass.setWindowBackgroundColor(color);
    } catch (err) {
      console.log(JSON.stringify(err));
      return;
    }
  }

  /**
   * 设置点击时是否支持切换焦点窗口
   * @param isFocusable 点击时是否支持切换焦点窗口。true表示支持；false表示不支持。
   */
  static async setWindowFocusable(isFocusable: boolean, windowClass?: window.Window): Promise<void> {
    try {
      if (!windowClass) {
        windowClass = AppUtils.getMainWindow();
      }
      return windowClass.setWindowFocusable(isFocusable);
    } catch (err) {
      console.log(JSON.stringify(err));
      return;
    }
  }

  /**
   * 设置窗口是否为可触状态
   * @param isTouchable 窗口是否为可触状态。true表示可触；false表示不可触。
   */
  static async setWindowTouchable(isTouchable: boolean, windowClass?: window.Window): Promise<void> {
    try {
      if (!windowClass) {
        windowClass = AppUtils.getMainWindow();
      }
      return windowClass.setWindowTouchable(isTouchable);
    } catch (err) {
      console.log(JSON.stringify(err));
      return;
    }
  }


  /**
   * 获取状态栏的高度，单位为px。
   */
  static getStatusBarHeight(): number {
    try {
      let windowClass = AppUtils.getMainWindow();
      let avoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
      return avoidArea.topRect.height;
    } catch (err) {
      console.log(JSON.stringify(err));
      return 30;
    }
  }

  /**
   * 获取底部导航条的高度，单位为px。
   */
  static getNavigationIndicatorHeight(): number {
    try {
      let windowClass = AppUtils.getMainWindow();
      let avoidArea = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
      return avoidArea.bottomRect.height;
    } catch (err) {
      console.log(JSON.stringify(err));
      return 0;
    }
  }


  /**
   * 设置沉浸式状态栏
   * @param isLayoutFullScreen 窗口的布局是否为沉浸式布局，true表示沉浸式布局；false表示非沉浸式布局。
   * @param enable 设置窗口全屏模式时状态栏、导航栏或底部导航条是否显示，true表示显示 false表示隐藏。
   * @param color 设置窗口的背景颜色。
   * @param systemBarProperties 状态栏、导航栏的属性
   */
  static setStatusBar(isLayoutFullScreen: boolean = true, enable: boolean = true,
    color: string = '#FFFFFF', systemBarProperties?: window.SystemBarProperties) {
    try {
      let windowClass = AppUtils.getMainWindow();
      windowClass.setWindowLayoutFullScreen(isLayoutFullScreen).then(() => {
        windowClass.setWindowBackgroundColor(color);
      }).catch((error: BusinessError) => {
        console.log(`setWindowLayoutFullScreen-异常 ~ code: ${error.code} -·- message: ${error.message}`);
      });
      windowClass.setWindowSystemBarEnable(enable ? ['status', 'navigation'] : []).then(() => {
        windowClass.setSpecificSystemBarEnabled("navigationIndicator", enable); //底部导航条。
      }).catch((error: BusinessError) => {
        console.log(`setWindowSystemBarEnable-异常 ~ code: ${error.code} -·- message: ${error.message}`);
      });
      if (systemBarProperties) {
        windowClass.setWindowSystemBarProperties(systemBarProperties).catch((error: BusinessError) => {
          console.log(`setWindowSystemBarProperties-异常 ~ code: ${error.code} -·- message: ${error.message}`);
        });
      }
    } catch (err) {
      console.log(JSON.stringify(err));
    }
  }


  /**
   * 获取当前应用的BundleInfo
   */
  static async getBundleInfo(): Promise<bundleManager.BundleInfo> {
    return await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
  }

  /**
   * 获取当前应用的BundleInfo
   */
  static getBundleInfoSync(): bundleManager.BundleInfo {
    return bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
  }


  /**
   * 获取应用包的名称。
   */
  static getBundleName(): string {
    return AppUtils.getBundleInfoSync().name;
  }

  /**
   * 获取vendor
   */
  static getVendor(): string {
   return AppUtils.getBundleInfoSync().vendor;
  }

  /**
   * 获取应用版本号。
   */
  static getVersionCode(): number {
    return AppUtils.getBundleInfoSync().versionCode;
  }

  /**
   * 获取应用版本名。
   */
  static getVersionName(): string {
    return AppUtils.getBundleInfoSync().versionName;
  }

  /**
   * 获取运行应用包所需要最高SDK版本号。
   */
  static getTargetVersion(): number {
    return AppUtils.getBundleInfoSync().targetVersion;
  }


  /**
   * 获取应用程序的配置信息
   */
  static async getAppInfo(): Promise<bundleManager.ApplicationInfo> {
    return (await AppUtils.getBundleInfo()).appInfo;
  }

  /**
   * 获取应用程序的配置信息
   */
  static getAppInfoSync(): bundleManager.ApplicationInfo {
    return AppUtils.getBundleInfoSync().appInfo;
  }

  /**
   * 主动退出整个应用
   */
  static exit() {
    AppUtils.getContext().terminateSelf();
  }

  /**
   * 延迟执行
   * @param func 回调
   * @param time 延迟时间
   */
  static funcDelayer(func: Function, time: number): void {
    let timerId = setTimeout(() => {
      try {
        func();
      } catch (error) {
      }
      clearTimeout(timerId);
    }, time);
  }

  /**
   * 跳转应用设置页面（调用此方法到设置，手动开启权限）
   */
  static async gotoAppSettingPage(uri: string = AppUtils.uri_info): Promise<void> {
    let context = AppUtils.getContext();
    let want: Want = {
      bundleName: 'com.huawei.hmos.settings', // 设置应用bundleName
      abilityName: 'com.huawei.hmos.settings.MainAbility', // 设置应用abilityName
      uri: uri, // 目标页面
      parameters: {
        // 拉起方应用包名
        bundleName: context.abilityInfo.bundleName,
        // 拉起方应用包名
        pushParams: context.abilityInfo.bundleName,
      }
    }
    return await context.startAbility(want);
  }

  /**
   * 获取pathStack
   */
  static getPathStack(): NavPathStack {
    const navStack: NavPathStack = HMRouterMgr.getPathStack(NavigationConstants.MAIN_NAVIGATION_ID) as NavPathStack
    return navStack
  }

  /**
   * 获取当前页面ID
   */
  static getCurrentPage() {
    const navStack = AppUtils.getPathStack()
    const pages = navStack.getAllPathName()
    if (pages) {
      const last = pages.length - 1
      return pages[last]
    }

    return ''
  }
}