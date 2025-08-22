import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import window from '@ohos.window';
import Want from '@ohos.app.ability.Want';
import PreferencesUtil from '../common/utils/PreferencesUtil';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';

import { router } from '@kit.ArkUI';

export default class EntryAbility extends UIAbility{
  //读取日历的权限
  permissions: Array<Permissions> = ['ohos.permission.READ_CALENDAR'];

  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
      hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');

      // 初始化Preferences
      await PreferencesUtil.loadPreference(this.context, 'MyPreferences')

      //使用 EventHub 来订阅事件
      let eventHub = this.context.eventHub;
      //订阅事件 eventHub.on
      // eventHub.on('eventTest',this.eventTest)
      //事件回调还可以使用匿名方法的形式：
      eventHub.on('eventTest',()=>{
        console.info('eventHub','eventTest');
      })
      //带参数的事件
      // eventHub.on('eventTestWithParams',(...data)=>{
      //   console.info('eventTestWithParams',`eventTestWithParams事件传递过来的参数为：${JSON.stringify(data)}`);
      //   console.info('eventTestWithParams',`eventTestWithParams事件传递过来的参数为：${JSON.stringify(data[0])}`);
      // })
      //带参数的事件，这样写也可以
      eventHub.on('eventTestWithParams',this.eventTestWithParams);
  }

  eventTestWithParams(...data:Object[]){
    console.info('eventTestWithParams',`eventTestWithParams事件传递过来的参数为：${JSON.stringify(data)}`);
    console.info('eventTestWithParams',`eventTestWithParams事件传递过来的参数为：${JSON.stringify(data[0])}`);
    this.context.eventHub.off('eventTest',this.eventTestWithParams);
  }

  eventTest(){
    console.info('eventHub','eventTest');

    // context为UIAbility实例的AbilityContext
    //发送完消息可以使用 eventHub.off 取消 事件订阅
    this.context.eventHub.off('eventTest',this.eventTest);
    // this.context.eventHub.off('eventTest');//如果不传callback，则取消订阅该事件下所有callback。
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    //多页面共享LocalStorage
    let record:Record<string,number> = {'localStorageShare':99}
    let storage: LocalStorage = new LocalStorage(record);
    //通过 windowStage.loadContent 加载LocalStorage
    windowStage.loadContent('pages/Splash', storage,(err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');

      let uiContext:  UIContext | undefined = windowStage.getMainWindowSync().getUIContext()
      AppStorage.setOrCreate('uiContext', uiContext);//ListSnapshot类中使用到了ImageUtils，ImageUtils中使用到了uiContext
    });
    windowStage.getMainWindow((err, data) => {
      // 1.获取应用主窗口
      let windowClass: window.Window = data;

      // 2.设置底部navigation导航栏显示、状态栏不显示。注意：需要显示哪个数组中就写哪个就行
      //status：顶部状态栏；navigation：底部导航栏
      //下面的数组中要设置“navigation”，如果不设置在有虚拟按键的情况下会不显示底部的导航
      windowClass.setWindowSystemBarEnable(['status','navigation'], (err) => {

      });
      // 3.设置全屏
      windowClass.setWindowLayoutFullScreen(true).then(() => {

      })

      windowClass.setWindowSystemBarProperties({
        statusBarColor: '#f56e1d',
        navigationBarColor: '#f56e1d',
        // 以下两个属性从API Version 8开始支持A03d00/JSAPP
        statusBarContentColor: '#f56e1d',
        navigationBarContentColor: '#f56e1d'
      })

      // 4.获取底部导航栏高度，此时的高度单位是px
      let navigationHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).bottomRect.height//底部
      let topStatusHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height//顶部
      AppStorage.SetOrCreate<number>('topStatusHeight', topStatusHeight)
      AppStorage.SetOrCreate<number>('navigationHeight', navigationHeight)

      this.requestPermission();
    })
  }

  /**
   * 在UIAbility中获取权限
   */
  requestPermission(){
    //判断是否已经申请过权限
    //注意：UIAbility中不能使用后缀为ets的文件，获取权限的话可以把获取权限的逻辑放在UIAbility中的onWindowStageCreate方法中。
    // PermissionUtils.checkPermissions(this.context,this.permissions)
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam){

  }
}
