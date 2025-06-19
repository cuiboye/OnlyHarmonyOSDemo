export class ResManager{
  static getSetting(): Resource{
    return $r('app.media.setting');
  }
  static getSharedDesc(): Resource{
    return $r('app.string.shared_desc');
  }
}