import 'package:file_picker/file_picker.dart';

import '../../../../data/models/letter_model.dart';
import '../../../../data/models/selected_department_model.dart';

class ExternalLetterDetailsArgs{
  final LetterModel letterModel;
  final bool openedFromReply;

  ExternalLetterDetailsArgs(this.letterModel, this.openedFromReply);
}
class UpdateLetterArgs{
  final LetterModel letterModel;
  final List<PlatformFile> letterFiles;
  final List<SelectedDepartmentModel?> selectedActionList;
  final List<SelectedDepartmentModel?> selectedKnowList;

  UpdateLetterArgs(this.letterModel, this.letterFiles,this.selectedActionList,this.selectedKnowList);
}