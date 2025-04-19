import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:logger/logger.dart';
import 'package:seba_app1/domain/app/notice/i_notice_repo.dart';
import 'package:seba_app1/domain/app/notice/notice_model.dart';

class NoticeRepo extends INoticeRepo {
  final collection = FirebaseFirestore.instance.collection('notices');

  @override
  Future<IList<NoticeModel>> getNotices() async {
    try {
      final QuerySnapshot snapshot = await collection.get();
      final data = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return NoticeModel.fromMap(data);
          })
          .toIList()
          .reversed;

      return data;
    } catch (e) {
      Logger().e(e.toString());
      return IList<NoticeModel>([]);
    }
  }
}
