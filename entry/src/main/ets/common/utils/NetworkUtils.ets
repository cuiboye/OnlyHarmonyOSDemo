import { connection } from '@kit.NetworkKit';
import { wifiManager } from '@kit.ConnectivityKit';

/**
 * 网络工具类
 */
export class NetworkUtils {

  /**
   * 检查默认数据网络是否被激活
   */
  static isNetworkAvailable(): Promise<boolean> {
    return connection.hasDefaultNet();
  }

  /**
   * 检查默认数据网络是否被激活
   */
  static isNetworkAvailableSync(): boolean {
    return connection.hasDefaultNetSync();
  }


  /**
   * 判断当前网络是否是Wi-Fi，否则是移动流量热点网络。
   */
  static async hasNetWiFi(): Promise<boolean> {
    let net = await connection.getDefaultNet();
    let netCapabilities = await connection.getNetCapabilities(net);
    let networkCap = netCapabilities.networkCap;
    if (networkCap) {
      return networkCap.indexOf(connection.NetCap.NET_CAPABILITY_NOT_METERED) >= 0
    }
    return false;
  }

  /**
   * 根据网络连接情况来判断网络类型
   */
  static getNetBearerType():string {
    let netBearType:string
    // 是否连接网络
    const isHasDefaultNet = connection.hasDefaultNetSync()
    if (isHasDefaultNet) {
      netBearType = NetworkUtils.getConNetCapabilities()
    } else {
      netBearType = '无网络'
    }
    return netBearType
  }

  /**
   *
   * 获取网络类型函数
   */
  static getConNetCapabilities():string {
    const netHandle = connection.getDefaultNetSync()
    const netCapabilities = connection.getNetCapabilitiesSync(netHandle)
    // 根据数组中的情况判断网络类型
    if (netCapabilities.bearerTypes.includes(connection.NetBearType.BEARER_CELLULAR)) {
      return '蜂窝网络'
    } else if (netCapabilities.bearerTypes.includes(connection.NetBearType.BEARER_WIFI)) {
      return 'WIFI'
    } else if (netCapabilities.bearerTypes.includes(connection.NetBearType.BEARER_ETHERNET)) {
      return '以太网'
    } else {
      return '无网络'
    }
  }


  /**
   * 获取网络类型
   */
  static async getNetBearType(): Promise<connection.NetBearType> {
    let net = await connection.getDefaultNet();
    let netCapabilities = await connection.getNetCapabilities(net);
    let netBearType = netCapabilities.bearerTypes[0];
    return netBearType;
  }


  /**
   * 获取当前设备的IP地址(设备连接Wi-Fi后)
   */
  static getIpAddress() {
    let ipAddress = wifiManager.getIpInfo().ipAddress;
    let ip = (ipAddress >>> 24) + "." + (ipAddress >> 16 & 0xFF)
      + "." + (ipAddress >> 8 & 0xFF) + "." + (ipAddress & 0xFF);
    return ip;
  }


  /**
   * 是否是WiFi连接
   *
   * @param context 上下文
   * @return true表示WiFi连接，并且可以上网。false表示WiFi没连接，或者WiFi连接了，但是不能上网
   */
  public static isWifiConnected(context: Context): boolean {
    try {
      let netHandle: connection.NetHandle = connection.getDefaultNetSync();
      if (netHandle == null) {
        return false;
      }
      let netCapabilities: connection.NetCapabilities = connection.getNetCapabilitiesSync(netHandle);
      if (netCapabilities == null) {
        return false;
      }
      let netCaps: Array<connection.NetCap> | undefined = netCapabilities.networkCap;
      let netBearTypes: Array<connection.NetBearType> | undefined = netCapabilities.bearerTypes;
      if (netCaps == undefined || netCaps == null || netBearTypes == undefined || netBearTypes == null) {
        return false;
      }
      // connection.NetCap.NET_CAPABILITY_VALIDATED表示连接了网络，并且可以上网
      return netCaps.includes(connection.NetCap.NET_CAPABILITY_VALIDATED)
        && netBearTypes.includes(connection.NetBearType.BEARER_WIFI);
    } catch (err) {
      return false;
    }
  }

  /**
   * 获取当前的ip
   * @returns
   */
  static getLocalIp(): string {
    let ipAddress = wifiManager.getIpInfo().ipAddress;
    let ip = (ipAddress >>> 24) + "." + (ipAddress >> 16 & 0xFF) + "." + (ipAddress >> 8 & 0xFF) + "." + (ipAddress & 0xFF);
    return ip;
  }

  /**
   * 获取手机网络类型
   * @param context
   * @returns
   */
  static getMobileType(context: Context): string {
    // todo
    return "wifi";
  }




}