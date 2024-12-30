import '../models/users/donor.dart';

class DonorIterator implements Iterator {
  final List<Donor> _donors;
  int _currentIndex = 0;

  DonorIterator(this._donors);

  @override
  bool hasNext() {
    return _currentIndex < _donors.length;
  }

  @override
  Donor next() {
    if (!hasNext()) throw Exception("No more donors");
    return _donors[_currentIndex++];
  }

  @override
  // TODO: implement current
  get current => throw UnimplementedError();

  @override
  bool moveNext() {
    // TODO: implement moveNext
    throw UnimplementedError();
  }
}
