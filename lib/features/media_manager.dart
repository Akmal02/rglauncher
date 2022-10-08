import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../data/configs.dart';
import '../data/models.dart';

class MediaManager {
  const MediaManager(this.appDirPath);

  final String appDirPath;

  Future<Uint8List> downloadImage(String link) async {
    final response = await http.get(Uri.parse(link));
    return response.bodyBytes;
  }

  File getSystemImageFile(System system) {
    return File('$appDirPath/$systemImageFolderName/${system.code}.png');
  }

  File getGameListFile(System system) {
    return File('$appDirPath/$gameListFolderName/${system.code}.csv');
  }

  List<System> getSavedGameList(List<System> allSystem) {
    final folder = Directory('$appDirPath/$gameListFolderName');
    final allSystemFiles = {
      for (final s in allSystem) s: getGameListFile(s),
    };
    final folderFiles = folder.listSync().map((e) => e.path).toList();
    List<System> foundSystem = [];
    for (final f in allSystemFiles.entries) {
      if (folderFiles.contains(f.value.path)) {
        foundSystem.add(f.key);
      }
    }
    return foundSystem;
  }

  void saveSystemImageFile(Uint8List bytes, System system) {
    final imageFile = getSystemImageFile(system);
    if (!imageFile.existsSync()) {
      imageFile.createSync(recursive: true);
    }
    imageFile.writeAsBytesSync(bytes);
  }

  File getGameMediaFile(Game game) {
    final gameFile = File(game.filepath);
    return File(
        '${gameFile.parent.path}/$gameMediaFolderName/${basename(gameFile.path)}.png');
  }

  bool isGameMediaFileExists(Game game) {
    return getGameMediaFile(game).existsSync();
  }

  void saveGameMediaFile(Uint8List imageBytes, Game game) {
    final imageFile = getGameMediaFile(game);

    if (!imageFile.existsSync()) {
      imageFile.createSync(recursive: true);
    }
    imageFile.writeAsBytesSync(imageBytes);
  }
}