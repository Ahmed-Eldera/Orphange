import '../users/donor.dart';
import 'Iterator.dart';

class DonorIterator implements AppIterator {
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


}
