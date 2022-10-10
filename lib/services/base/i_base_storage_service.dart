import '../../models/abstract/i_base_model.dart';

/// Created by Yunus Emre Yıldırım
/// on 6.10.2022

abstract class IBaseStorageService<T extends IBaseModel> {
  Future<List<T>?> getAll();

  Future<String?> add(T item);

  Future<String?> update(T item);

  Future<bool?> delete(T item);
}
