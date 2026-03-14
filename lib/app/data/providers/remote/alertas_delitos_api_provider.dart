part of '../providers_impl.dart';

class AlertasDelitosApiProviderImpl extends AlertasDelitosRepository {
  @override
  Future<List<CatalogoModel>> consultaCatalogos(int idVariable) async {
    try {
      final segmento = "catalogos/v2/variables/$idVariable/atributos";

      final jsonResponse = await UrlApiProvider.getFullUrl(
        url: Host.gethostApis() + segmento,
      );

      final model = catalogosAlertaModelFromJson(jsonResponse);
      return model.result;
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }

  @override
  Future<EventoEntity> crearEvento(EventoEntity evento) async {
    try {
      final segmento = "v1/eventos";
      final url = Host.gethostApis() + segmento;

      final body = EventoModel.fromEntity(evento).toJson();
      final headers = await UrlApiProvider.getheaders();

      final response = await http
          .post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      )
          .timeout(
        Duration(
          seconds: AppConfig.AmbienteUrl == Ambiente.produccion ? 8 : 30,
        ),
      );

      print("crearEvento-url: $url");
      print("crearEvento-body: ${jsonEncode(body)}");
      print("crearEvento-statusCode: ${response.statusCode}");
      print("crearEvento-responseBody: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        final model = EventoModel.fromJson(jsonMap);
        return model;
      } else {
        throw ServerException.StatusCode(statusCode: response.statusCode);
      }
    } catch (e) {
      throw ExceptionHelper.captureError(e);
    }
  }
}
