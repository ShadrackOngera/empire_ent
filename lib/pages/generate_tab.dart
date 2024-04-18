import 'package:empire_ent/controllers/database_controller.dart';
import 'package:empire_ent/services/auth/auth_service.dart';
import 'package:empire_ent/services/pdf/pdf_generator.dart';
import 'package:empire_ent/utils/widget_helper.dart';
import 'package:empire_ent/widgets/primary_button.dart';
import 'package:empire_ent/widgets/primary_text.dart';
import 'package:empire_ent/widgets/primary_text_field.dart';
import 'package:empire_ent/widgets/quantity_selector.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_saver/file_saver.dart';

class GenerateTab extends StatefulWidget {
  const GenerateTab({super.key});

  @override
  State<GenerateTab> createState() => _GenerateTabState();
}

class _GenerateTabState extends State<GenerateTab> {
  TextEditingController ticketIdController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController ticketTypeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final saveDetailsKey = GlobalKey<FormState>();
  DatabaseController databaseController = Get.put(DatabaseController());
  bool isLoading = false;

  Future<void> saveFile(Uint8List bytes, String name) async {
    setState(() {
      isLoading = true;
    });

    try {
      final Directory dir = await getTemporaryDirectory();
      final File file = File('${dir.path}/$name.pdf');
      await file.writeAsBytes(bytes);

      Share.shareFiles(['${dir.path}/$name.pdf']);
    } catch (e) {
      WidgetHelper.snackbar(
        '',
        'Error saving PDF: $e',
      );
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void clearForm() {
    nameController.clear();
    ticketIdController.clear();
    phoneNumberController.clear();
    emailController.clear();
    ticketTypeController.clear();
    quantityController.clear();
  }

  saveAndGenerate() {
    setState(() {
      isLoading = true;
    });
    databaseController.currentName.value = nameController.text;
    databaseController.currentTicketId.value = ticketIdController.text;
    databaseController.currentEmail.value = emailController.text;
    databaseController.currentPhoneNumber.value = phoneNumberController.text;
    if (saveDetailsKey.currentState!.validate()) {
      DatabaseController()
          .saveTicket(
        nameController.text,
        ticketIdController.text,
        phoneNumberController.text,
        emailController.text,
        databaseController.currentTicketType.value,
        databaseController.currentQuantity.value,
      )
          .then(
        (value) async {
          var doc = await generatePdf(
            email: databaseController.currentEmail.value,
            ticketType: databaseController.currentTicketType.value,
            quantity: databaseController.currentQuantity.value,
            ticketId: databaseController.currentTicketId.value,
          );
          var bytes = await doc.save();
          await saveFile(bytes, 'Ticket');
        },
      );
      clearForm();
    } else {
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  List<String> list = <String>[
    'Single',
    'Group',
    'Couple',
    'VIP',
  ];
  String dropdownValue = 'Single';
  String _email = 'Loading...';
  final AuthService _authService = AuthService();
  Future<void> _fetchEmail() async {
    User? user =
        _authService.getCurrentUser(); // Use getCurrentUser() from AuthService
    if (user != null) {
      setState(() {
        _email = user.email ?? 'Email not found';
      });
    } else {
      setState(() {
        _email = 'No user logged in';
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _fetchEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const CircularProgressIndicator()
        : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 15),
            child: (_email == 'mark@gmail.com' ||
                    _email == 'shadrack@gmail.com')
                ? Form(
                    key: saveDetailsKey,
                    child: Column(
                      children: [
                        PrimaryTextField(
                          label: 'Name',
                          obsecureText: false,
                          controller: nameController,
                          // hintText: 'Name',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PrimaryTextField(
                          label: 'Ticket Id',
                          obsecureText: false,
                          controller: ticketIdController,
                          // hintText: 'Ticket Id',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PrimaryTextField(
                          label: 'Phone Number',
                          obsecureText: false,
                          controller: phoneNumberController,
                          // hintText: 'Phone Number',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PrimaryTextField(
                          label: 'Email',
                          obsecureText: false,
                          controller: emailController,
                          // hintText: 'Email',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PrimaryText(
                                    text: 'Ticket Type',
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                  DropdownButtonFormField<String>(
                                    value: list.contains(databaseController
                                            .currentTicketType.value)
                                        ? databaseController
                                            .currentTicketType.value
                                        : 'Single',
                                    isExpanded: true,
                                    onChanged: (value) {
                                      databaseController
                                          .currentTicketType.value = value!;
                                    },
                                    items: list.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: PrimaryText(
                                          text: value,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                        ),
                                      );
                                    }).toList(),
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                PrimaryText(
                                  text: 'Quantity',
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                                QuantitySelector(
                                  onChanged: (value) {
                                    databaseController.currentQuantity.value =
                                        value;
                                  },
                                ),
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PrimaryButton(
                          onTap: () => saveAndGenerate(),
                          child: PrimaryText(
                            text: 'Save and Generate',
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: PrimaryText(
                      text: 'Scan Users On The Scan Tab',
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
          );
  }

  Future<void> savePdfFile(Uint8List bytes) async {
    await FileSaver.instance.saveFile(
      name: 'name',
      bytes: bytes,
      ext: 'pdf',
    );
  }
}
