import { distributedKVStore } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

/**
 * kvManager数据库
 */
export default class KvManagerUtils{
  //context不能在静态方法中初始化，也不能放在全局中（class外面）
  static init(context:common.UIAbilityContext){
    let kvManager: distributedKVStore.KVManager;
    let kvStore: distributedKVStore.SingleKVStore | undefined = undefined;
    const kvManagerConfig: distributedKVStore.KVManagerConfig = {
      context: context,
      bundleName: 'com.example.myapplication'
    }
    try {
      kvManager = distributedKVStore.createKVManager(kvManagerConfig);
      console.info('Succeeded in creating KVManager.');
      try {
        const options: distributedKVStore.Options = {
          createIfMissing: true,
          encrypt: true,
          backup: false,
          autoSync: false,
          kvStoreType: distributedKVStore.KVStoreType.SINGLE_VERSION,
          securityLevel: distributedKVStore.SecurityLevel.S1
        };
        //storeid需要符合规则，否则会报错
        kvManager.getKVStore<distributedKVStore.SingleKVStore>('123456dbid', options, (err, store: distributedKVStore.SingleKVStore) => {
          if (err) {
            console.error(`Failed to get KVStore. Code:${err.code},message:${err.message}`);
            return;
          }
          console.info('Succeeded in getting KVStore.');
          kvStore = store;
        });
      } catch (e) {
        let error = e as BusinessError;
        console.error(`An unexpected error occurred. Code:${error.code},message:${error.message}`);
      }
    } catch (e) {
      let error = e as BusinessError;
      console.error(`Failed to create KVManager. Code:${error.code},message:${error.message}`);
    }

    if (kvStore !== undefined) {
      kvStore = kvStore as distributedKVStore.SingleKVStore;
      //进行后续操作，具体的可以查看官网
      //https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/data-backup-and-restore-V5
      //...
    }
  }
}