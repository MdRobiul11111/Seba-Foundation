import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:seba_app1/domain/app/promotion/promotion_model.dart';

abstract class IPromotionRepo {
  Future<IList<PromotionModel>> getPromotion();
}
