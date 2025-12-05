import 'package:timeago/timeago.dart' as timeago;

bool _timeagoInited = false;

void _ensureZhLocale() {
  if (_timeagoInited) return;
  timeago.setLocaleMessages('zh_CN', timeago.ZhCnMessages());
  timeago.setLocaleMessages('zh', timeago.ZhMessages());
  _timeagoInited = true;
}

String formatDateAgo(DateTime dateTime, {String locale = 'zh_CN'}) {
  _ensureZhLocale();
  return timeago.format(dateTime, locale: locale);
}

String formatDateAgoFromString(String isoString, {String locale = 'zh_CN'}) {
  final dt = DateTime.tryParse(isoString);
  if (dt == null) return '';
  return formatDateAgo(dt, locale: locale);
}

String formatDateAgoFromMilliseconds(int milliseconds, {String locale = 'zh_CN'}) {
  final dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  return formatDateAgo(dt, locale: locale);
}
