abstract class DAO<T> {
  Future<bool> create(T item);
  Future<T> search(String title);
  Future<List<T>> getAll();
  Future<bool> update(T item);
  Future<bool> delete(T item);
}