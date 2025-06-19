import prompt from '@ohos.prompt'
import preferencesUtil from '../../common/utils/PreferencesUtil'

/**
 * 持久化数据
 * 1）Preferences
 */
@Entry
@Component
struct SaveDataDemo {
  @State message: string = 'Hello World'

  build() {
    Column() {
      Button('存储Preferences').onClick(() => {
        //可以把MyPreferences这个name放到工具类中
        preferencesUtil.putPreferenceValue('MyPreferences', 'PersonName', '刘德华')
      }).margin({top:60})
      Button('获取Preferences').onClick(async () => {
        const value = await preferencesUtil.getPreferenceValue('MyPreferences', 'PersonName', '') as string
        console.log(`获取的value为：${value}`)
        prompt.showToast({
          message: value,
          duration: 2000
        });
      })
    }
    .height('100%')
  }
}