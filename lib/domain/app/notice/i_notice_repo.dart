import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:seba_app1/domain/app/notice/notice_model.dart';

abstract class INoticeRepo {
  Future<IList<NoticeModel>> getNotices();
}
