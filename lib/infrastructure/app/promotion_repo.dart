import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:logger/logger.dart';
import 'package:seba_app1/domain/app/promotion/i_promotion_repo.dart';
import 'package:seba_app1/domain/app/promotion/promotion_model.dart';

class PromotionRepo extends IPromotionRepo {
  final collection = FirebaseFirestore.instance.collection('promotions');

  @override
  Future<IList<PromotionModel>> getPromotion() async {
    try {
      final QuerySnapshot snapshot = await collection.get();
      final data = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return PromotionModel.fromMap(data);
          })
          .toIList()
          .reversed;

      return data;
    } catch (e) {
      Logger().e(e.toString());
      return IList<PromotionModel>([]);
    }
  }
}
