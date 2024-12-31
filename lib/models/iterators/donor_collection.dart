import '../users/donor.dart';
import 'donor_iterator.dart';

class DonorCollection {
  final List<Donor> _donors;

  DonorCollection(this._donors);

  DonorIterator getIterator() {
    return DonorIterator(_donors);
  }
}
