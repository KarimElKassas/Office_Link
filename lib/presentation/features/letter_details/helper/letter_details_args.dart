import 'package:file_picker/file_picker.dart';
import 'package:foe_archiving/presentation/features/archived_letters/outgoing/bloc/outgoing_archived_letters_cubit.dart';

import '../../../../data/models/letter_model.dart';
import '../../../../data/models/selected_department_model.dart';
import '../../archived_letters/incoming/bloc/incoming_archived_letters_cubit.dart';

class LetterDetailsArgs{
  final IncomingArchivedLettersCubit? incomingArchivedLettersCubit;
  final OutgoingArchivedLettersCubit? outgoingArchivedLettersCubit;
  final LetterModel letterModel;
  final bool openedFromReply;

  LetterDetailsArgs(this.letterModel, this.openedFromReply,{this.incomingArchivedLettersCubit,this.outgoingArchivedLettersCubit});
}
class UpdateLetterArgs{
  final LetterModel letterModel;
  final List<PlatformFile> letterFiles;
  final List<SelectedDepartmentModel?> selectedActionList;
  final List<SelectedDepartmentModel?> selectedKnowList;

  UpdateLetterArgs(this.letterModel, this.letterFiles,this.selectedActionList,this.selectedKnowList);
}
class PdfArgs{
  final PlatformFile pdf;
  final int index;

  PdfArgs(this.pdf, this.index);
}