import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lacteos_san_esteban_app/models/venta.dart';
import 'package:get/get.dart';

class ProveedoresPage extends StatelessWidget {
  ProveedoresPage({super.key});

  final filters = ["Nombre", "Telefono", "Correo", "Direccion"];
  var appliedFilters = <String>[].obs;
  final formatDate = DateFormat("yyyy/MM/dd h:mm a");
  final proveedoresStream = FirebaseFirestore.instance
      .collection("proveedores")
      .withConverter<Persona>(
          fromFirestore: (snap, _) => Persona.fromJson(snap.data()!),
          toFirestore: (proveedor, _) => proveedor.toJson())
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Proveedores"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Wrap(
                    spacing: 4.0,
                    children: filters
                        .map(
                          (e) => Obx(
                            () => ChoiceChip(
                              label: Row(
                                children: [
                                  Text(e),
                                  Icon(
                                    appliedFilters.contains(e)
                                        ? Icons.close
                                        : Icons.expand_more,
                                  ),
                                ],
                              ),
                              selected: appliedFilters.contains(e),
                              onSelected: (value) {
                                print(value);
                                if (value) {
                                  appliedFilters.add(e);
                                  switch (e) {
                                    case "Nombre":
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Cliente"),
                                                  TextButton(
                                                    onPressed: () {},
                                                    child:
                                                        const Text("Aplicar"),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                      break;
                                    case "Correo":
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Empleado"),
                                                  TextButton(
                                                    onPressed: () {},
                                                    child:
                                                        const Text("Aplicar"),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                      break;
                                    case "Telefono":
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Fecha"),
                                                  TextButton(
                                                    onPressed: () {},
                                                    child:
                                                        const Text("Aplicar"),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                      break;
                                    default:
                                  }
                                  print(appliedFilters);
                                  return;
                                }
                                appliedFilters.remove(e);
                                print(appliedFilters);
                                /* Navigator.of(context).popAndPushNamed("/home"); */
                              },
                            ),
                          ),
                        )
                        .toList(),
                  )
                ],
              ),
            ),
          )),
      body: StreamBuilder(
          stream: proveedoresStream,
          builder: (context, snap) {
            if (snap.hasError) {
              return const Center(
                child: Text("Ups ha ocurrido un error"),
              );
            }
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(10.0),
              children: snap.data!.docs.map(
                (e) {
                  const boldtext = TextStyle(fontWeight: FontWeight.bold);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.data().nombre,
                            style: boldtext,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Correo: ${e.data().correo}"),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Telefono: ${e.data().telefono}"),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("Direccion: ${e.data().direccion}"),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text("Ver compras a ${e.data().nombre}"),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/proveedores_form");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
