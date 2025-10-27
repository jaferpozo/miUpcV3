import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:pne/app/presentation/gps/gps_impl_helper.dart';

import 'core/utils/feactures/di_feactures.dart';
import 'data/providers/providers_impl.dart';
import 'data/repository/data_repositories.dart';
import 'domain/repositories/domain_repositories.dart';

class DependencyInjection extends Bindings{
  static ini(){

    // Repository
    Get.lazyPut<ItemsRepository>(()=>ItemsApiImpl(itemsApiProviderImpl: Get.find()),fenix: true);
    Get.lazyPut<ModulosRepository> (() => ModulosApiImpl(Get.find()), fenix: true);
    Get.lazyPut<ServiciosRepository> (() => ServiciosApiImpl(Get.find()), fenix: true);
    Get.lazyPut<MapaUpcRepository> (() => MapaUpcApiImpl(Get.find()), fenix: true);
    Get.lazyPut<RegistroUsuarioRepository> (() => RegistroUsuarioApiImpl(Get.find()), fenix: true);
    Get.lazyPut<AlertaViolenciaRepository>(()=>AlertaViolenciaApiImpl(alertaViolenciaApiProviderImpl: AlertaViolenciaApiProviderImpl()),fenix: true);

    // Data sources
    Get.lazyPut<ItemsApiProvider>(()=>ItemsApiProviderImpl(), fenix: true);
    Get.lazyPut<ModulosApiProvider>(()=>ModulosApiProviderImpl(), fenix: true);
    Get.lazyPut<ServiciosApiProvider>(()=>ServiciosApiProviderImpl(), fenix: true);
    Get.lazyPut<MapaUpcApiProvider>(()=>MapaUpcApiProviderImpl(), fenix: true);
    Get.lazyPut<RegistroUsuarioApiProvider>(()=>RegistroUsuarioApiProviderImpl(), fenix: true);
    Get.lazyPut<RegistroAlertaVehiculosApiProvider>(()=>RegistroAlertaVehiculosApiProviderImpl(), fenix: true);


    Get.lazyPut<LocalStorageRepository> (() => LocalStoreProviderImpl(), fenix: true);
    Get.lazyPut<LocalStoreProviderImpl> (() => LocalStoreProviderImpl(), fenix: true);
    Get.lazyPut<LocalStoreImpl> (() => LocalStoreImpl(), fenix: true);



    // Data sources


    Get.put(GpsController());
    DependencyInjectionFeactures.init();
  }

  @override
  void dependencies() {
    ini();
  }


}