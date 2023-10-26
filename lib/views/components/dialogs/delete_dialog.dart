import 'package:flutter/material.dart';
import 'package:instant_gram/views/components/constants/strings.dart';
import 'package:instant_gram/views/components/dialogs/alert_dialog_model.dart';

@immutable
class DeleteDialog extends AlertDialogModel<bool> {
  const DeleteDialog({
    required String titleOfObjectToDelete,
  }) : super(
          message:
              "${Strings.areYouSureYouWantToDeleteThisPost} $titleOfObjectToDelete?",
          title: "${Strings.delete} $titleOfObjectToDelete",
          buttons: const {
            Strings.cancel: false,
            Strings.delete: true,
          },
        );
}
