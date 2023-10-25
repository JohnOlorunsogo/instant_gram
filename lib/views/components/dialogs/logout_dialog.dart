import 'package:flutter/material.dart';
import 'package:instant_gram/views/components/constants/strings.dart';
import 'package:instant_gram/views/components/dialogs/alert_dialog_model.dart';

@immutable
class LogoutDialog extends AlertDialogModel<bool> {
  const LogoutDialog()
      : super(
          message: Strings.areYouSureYouWantToLogOutOfTheApp,
          title: Strings.logOut,
          buttons: const {
            Strings.cancel: false,
            Strings.logOut: true,
          },
        );
}
