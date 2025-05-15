import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/constants/appwrite_constants.dart';

// all appwrite providers are defined here

final appwriteClientProvider = Provider<Client>((ref) {
  final client = Client();
  client
      .setProject(AppwriteConstants.projectId)
      .setEndpoint(AppwriteConstants.endPoint);

  return client;
});

final appwriteAccountProvider = Provider<Account>((Ref ref) {
  final clientAccount = ref.watch(appwriteClientProvider);
  return Account(clientAccount);
});

final appwriteDatabasesProvider = Provider<Databases>((Ref ref) {
  final clientDatabases = ref.watch(appwriteClientProvider);
  return Databases(clientDatabases);
});

final appwriteStorageProvider = Provider((Ref ref) {
  final clientStorage = ref.watch(appwriteClientProvider);
  return Storage(clientStorage);
});
