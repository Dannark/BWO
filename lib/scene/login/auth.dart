abstract class AuthService {
  void login();

  void logout();

  void retriveCharacterData(String characterName);

  Future<bool> isNameAvailable(String characterName);

  Future createCharacterForUser(String characterName);

  Future<String> getCharacterNameFromUserAccount();
}
