import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:seba_app1/domain/app/representive/i_representive_repo.dart';
import 'package:seba_app1/infrastructure/app/representive_repo.dart';

final representiveRepoProvider = FutureProvider<IRepresentiveRepo>((ref) async {
  return RepresentiveRepo();
});
