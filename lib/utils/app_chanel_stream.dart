import 'dart:async';
import 'package:proyecto/model/chanel_model.dart';
import 'package:proyecto/utils/app_firebase.dart';

class AppChanelStream {
  String id = '';
  late List<Chanel> chanels = [];

  final StreamController<List<Chanel>> _getChanels =
      StreamController<List<Chanel>>();
  Stream<List<Chanel>> get getChanels => _getChanels.stream;

  AppChanelStream(id) {
    AppDataBase.shared.getChanelInUser(id).listen((data) async {
      Map chanelsMap = data.snapshot.value as Map;
      for (int i = 0; i < chanelsMap.keys.length; i++) {
        AppDataBase.shared
            .getChanelStream(chanelsMap.keys.elementAt(i) as String)
            .listen((chanel) async {
          Chanel newChanel = await Chanel.fromMapOnly(
              chanelsMap.keys.elementAt(i), chanel.snapshot.value as Map);
          late bool add = true;
          for (Chanel element in chanels) {
            if (element.id == newChanel.id) {
              add = false;
              element.mensajes = newChanel.mensajes;
              element.nombre = newChanel.nombre;
              element.descripcion = newChanel.descripcion;
              element.fechaCreacion = newChanel.fechaCreacion;
              element.creador = newChanel.creador;
              element.administradores = newChanel.administradores;
              element.usuarios = newChanel.usuarios;
            }
          }
          if (add) {
            chanels.add(newChanel);
          }
          chanels.sort((a, b) {
            if (b.mensajes.isEmpty || a.mensajes.isEmpty) {
              return b.fechaCreacion.compareTo(a.fechaCreacion);
            } else {
              return b.mensajes.first.fechaEnvio
                  .compareTo(a.mensajes.first.fechaEnvio);
            }
          });
          _getChanels.add(chanels);
        });
      }
    });
  }

  dispose() {
    _getChanels.close();
  }
}
