part of '../providers_impl.dart';

const _PREF_TOKEN = 'TOKEN';
const _PREF_USUARIO = 'USER';

const _PREF_MAIL = 'MAIL';
const _PREF_ACUERDO = 'ACUERDO';
const _PREF_ID_USER = 'IDUSER';

const _PREF_ITEMS = 'ITEMS';
const _PREF_TELEFONO = 'TELEFONO';
const _PREF_FOTO='FOTO';
const _PREF_LIST_MODULOS = 'LIST_MODULO';

const _PREF_LIST_SERVICIOS = 'LIST_SERVICIOS';
const _PREF_LIST_SERVICIOSPOLI = 'LIST_SERVICIOSPOLI';
const _PREF_ITEMSPOLI = 'ITEMSPOLI';
const _PREF_PASS = 'PASS';

const _PREF_APP_INICIAL =
    'APP_INICIAL'; // sirve para controlar si el usuario recien instalo la aplicacion y mostrarle directamente el login
const _PREF_TIENE_HUELLA = 'TIENE_HUELLA';
const _PREF_USER_NAME = 'USER_NAME';
const _PREF_THEME = 'THEME_DARK';
const _PREF_CONTADOR_FALLIDO =
    'CONTADOR_FALLIDO'; //Cuando el usuario a cambiado la clave y al precionar la huella por segunda  vez y no ingresa tiene que reiniciarse
//para que se loguee con su nueva cuenta

class LocalStoreProviderImpl extends LocalStorageRepository {
  @override
  Future<void> clearAllData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  Future<String> getDatosAcuerdo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_PREF_ACUERDO) ?? '';
  }

  @override
  Future<bool> setDatosAcuerdo(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_ACUERDO, value);
    return true;
  }

  @override
  Future<String> getDatosMail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_PREF_MAIL) ?? '';
  }

  @override
  Future<String> getDatosUsuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_PREF_USUARIO) ?? '';
  }

  @override
  Future<bool> setDatosMail(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_MAIL, value);
    return true;
  }
  @override
  Future<bool> setIdUsuer(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_PREF_ID_USER, value);
    return true;
  }
  @override
  Future<int> getIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_PREF_ID_USER) ?? 0;
  }

  @override
  Future<bool> setTelefono(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_TELEFONO, value);
    return true;
  }
  @override
  Future<String> getTelefono() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_PREF_TELEFONO) ?? "";
  }
  @override
  Future<bool> setDatosUsuario(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_USUARIO, value);
    return true;
  }

  @override
  Future<List<Modulo>> getListModulos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _json = prefs.getString(_PREF_LIST_MODULOS) ?? '';
    if (_json.length == 0) {
      return [];
    }
    log(_json);

    Map<String, dynamic> datos = json.decode(_json);
    return List<Modulo>.from(datos["datos"].map((x) => Modulo.fromJson(x)));
  }

  @override
  Future<Uint8List?> getFoto() async {
    final prefs = await SharedPreferences.getInstance();
    String? base64String = prefs.getString(_PREF_FOTO);
    if (base64String != null) {
      return base64Decode(base64String);
    } else {
      return null;
    }
  }

  @override
  Future<void> setFoto(Uint8List imageBytes) async {
    final prefs = await SharedPreferences.getInstance();
    String base64String = base64Encode(
        imageBytes); // Convertir los bytes en base64
    await prefs.setString(_PREF_FOTO, base64String); // Guardar como string
  }

  @override
  Future<bool> setDatosListaModulos({required List<Modulo> listModulos}) async {
    Map<String, dynamic> toJson() =>
        {
          "datos": List<dynamic>.from(listModulos.map((x) => x.toJson())),
        };
    String datos = json.encode(toJson());
    log(datos);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_LIST_MODULOS, datos);
    return true;
  }

  @override
  Future<List<Servicio>> getListServicios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _json = prefs.getString(_PREF_LIST_SERVICIOS) ?? '';

    if (_json.length == 0) {
      return [];
    }
    log(_json);

    Map<String, dynamic> datos = json.decode(_json);
    return List<Servicio>.from(datos["datos"].map((x) => Servicio.fromJson(x)));
  }

  @override
  Future<bool> setDatosListaServicios({
    required List<Servicio> listServicios,
  }) async {
    Map<String, dynamic> toJson() =>
        {
          "datos": List<dynamic>.from(listServicios.map((x) => x.toJson())),
        };

    String datos = json.encode(toJson());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_LIST_SERVICIOS, datos);
    return true;
  }

  @override
  Future<List<ItemOffLine>> getListItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _json = prefs.getString(_PREF_ITEMS) ?? '';

    if (_json.length == 0) {
      return [];
    }
    log(_json);

    Map<String, dynamic> datos = json.decode(_json);
    return List<ItemOffLine>.from(
        datos["datos"].map((x) => ItemOffLine.fromJson(x)));
  }


  @override
  Future<bool> setDatosListaItems(
      {required List<ItemOffLine> listItems}) async {
    Map<String, dynamic> toJson() =>
        {
          "datos": List<dynamic>.from(listItems.map((x) => x.toJson())),
        };

    String datos = json.encode(toJson());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_ITEMS, datos);
    return true;
  }


  @override
  Future<List<ItemOffLine>> getListItemsPoli() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _json = prefs.getString(_PREF_ITEMSPOLI) ?? '';

    if (_json.length == 0) {
      return [];
    }
    log(_json);

    Map<String, dynamic> datos = json.decode(_json);
    return List<ItemOffLine>.from(
        datos["datos"].map((x) => ItemOffLine.fromJson(x)));
  }


  @override
  Future<bool> setDatosListaItemsPoli(
      {required List<ItemOffLine> listItemsPoli}) async {
    Map<String, dynamic> toJson() =>
        {
          "datos": List<dynamic>.from(listItemsPoli.map((x) => x.toJson())),
        };
    String datos = json.encode(toJson());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_ITEMSPOLI, datos);
    return true;
  }


  @override
  Future<bool> setDatosListaServiciosPoli(
      {required List<Servicio> listServiciosPoli}) async {
    Map<String, dynamic> toJson() =>
        {
          "datos": List<dynamic>.from(listServiciosPoli.map((x) => x.toJson())),
        };

    String datos = json.encode(toJson());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_PREF_LIST_SERVICIOSPOLI, datos);
    return true;

  }

  @override
  Future<List<Servicio>> getListServiciosPoli() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String _json = prefs.getString(_PREF_LIST_SERVICIOSPOLI) ?? '';

    if (_json.length == 0) {
      return [];
    }
    log(_json);

    Map<String, dynamic> datos = json.decode(_json);
    return List<Servicio>.from(datos["datos"].map((x) => Servicio.fromJson(x)));
  }
}