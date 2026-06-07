import 'package:flutter_test/flutter_test.dart';
import 'package:tapella/features/services/domain/usecases/listings_usecases.dart';

import '../../../helpers/fake_repositories.dart';
import '../../../helpers/fixtures.dart';

void main() {
  late FakeListingsRepository repository;

  setUp(() {
    repository = FakeListingsRepository();
  });

  group('GetAllListingsUseCase', () {
    test('returns listings from repository with filters', () async {
      repository.listingsResult = Fixtures.listingsResult(isStale: true);
      final useCase = GetAllListingsUseCase(repository);

      final result = await useCase.call(search: 'pipe', category: 'Plumbing');

      expect(result.data, [Fixtures.listing]);
      expect(result.isStale, isTrue);
      expect(repository.lastSearch, 'pipe');
      expect(repository.lastCategory, 'Plumbing');
    });
  });

  group('GetListingDetailsUseCase', () {
    test('returns listing detail by id', () async {
      repository.listingByIdResult = Fixtures.listingDetailResult();
      final useCase = GetListingDetailsUseCase(repository);

      final result = await useCase.call('listing-1');

      expect(result.data.id, 'listing-1');
    });
  });

  group('GetMyListingsUseCase', () {
    test('returns provider listings', () async {
      repository.myListingsResult = [Fixtures.listing];
      final useCase = GetMyListingsUseCase(repository);

      final result = await useCase.call();

      expect(result, [Fixtures.listing]);
    });
  });

  group('CreateListingUseCase', () {
    test('creates listing through repository', () async {
      repository.createResult = Fixtures.listing;
      final useCase = CreateListingUseCase(repository);

      final result = await useCase.call({
        'title': 'Pipe Repair',
        'description': 'Fast plumbing service',
        'category': 'Plumbing',
        'priceEtb': 500,
        'location': 'Addis Ababa',
        'phone': '+251900000002',
      });

      expect(result, Fixtures.listing);
    });
  });

  group('UpdateListingUseCase', () {
    test('updates listing through repository', () async {
      repository.updateResult = Fixtures.listing;
      final useCase = UpdateListingUseCase(repository);

      final result = await useCase.call('listing-1', {'title': 'Updated'});

      expect(result, Fixtures.listing);
    });
  });

  group('DeleteListingUseCase', () {
    test('deletes listing through repository', () async {
      final useCase = DeleteListingUseCase(repository);

      await useCase.call('listing-1');

      expect(repository.lastDeletedId, 'listing-1');
    });
  });
}
