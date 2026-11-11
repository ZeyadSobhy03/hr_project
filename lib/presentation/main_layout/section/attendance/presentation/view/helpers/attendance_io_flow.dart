import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hr_project/core/errors/app_exception.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/services/attendance_export_service.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/services/attendance_import_service.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/helpers/attendance_dialogs.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view_model/attendance_view_model.dart';

import '../../../data/model/attendance_record.dart';
import 'attendance_toast_helper.dart';

abstract final class AttendanceIoFlow {
  static Future<void> export(
      DailyAttendanceCubit cubit,
      DailyAttendanceState state, {
        required bool pdf,
      }) async {
    try {
      final rows = await cubit.fetchAllForExport();
      if (pdf) {
        await AttendanceExportService.exportPdf(rows: rows, date: state.date);
      } else {
        await AttendanceExportService.exportExcel(rows: rows, date: state.date);
      }
      AttendanceToastHelper.show('تم التصدير بنجاح');
    } catch (_) {
      AttendanceToastHelper.show('تعذر تصدير الملف', isError: true);
    }
  }

  static Future<void> import(
      BuildContext context,
      DailyAttendanceCubit cubit,
      ) async {
    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      if (files.isEmpty) return;

      final parsed = await _parse(files.first);
      if (parsed == null) return;
      if (!context.mounted) return;

      if (parsed.rows.isEmpty) {
        await AttendanceDialogs.importSummary(
          context,
          inserted: 0,
          deleted: 0,
          errors: parsed.errors,
        );
        return;
      }

      final absent = parsed.rows
          .where((r) => r.status == ImportStatus.absent)
          .length;
      final present = parsed.rows.length - absent;

      final ok = await AttendanceDialogs.confirm(
        context,
        title: 'استيراد من ملف',
        message:
        'سيتم تسجيل $present حاضر، وحذف سجل حضور $absent غائب (لو موجود). متابعة؟',
        confirmText: 'استيراد',
        danger: absent > 0,
      );
      if (!ok || !context.mounted) return;

      final result = await cubit.importRows(parsed.rows);
      if (result == null || !context.mounted) return;

      final rowsByNumber = {for (final r in parsed.rows) r.rowNumber: r};

      final errors = [
        ...parsed.errors,
        ...result.errors.map((e) {
          final row = rowsByNumber[e.rowNumber];
          return row == null ? e : e.withRow(row);
        }),
      ]..sort((a, b) => a.rowNumber.compareTo(b.rowNumber));


      await AttendanceDialogs.importSummary(
        context,
        inserted: result.inserted,
        deleted: result.deleted,
        errors: errors,
      );
    } catch (e) {
      AttendanceToastHelper.show(
        'حدث خطأ أثناء استيراد الملف: $e',
        isError: true,
      );
    }
  }

  static Future<ParsedImport?> _parse(PlatformFile file) async {
    try {
      final bytes = await file.readAsBytes();
      return AttendanceImportService.parse(bytes);
    } on AppException catch (e) {
      AttendanceToastHelper.show(e.message, isError: true);
    } catch (e) {
      AttendanceToastHelper.show('تعذر قراءة الملف: $e', isError: true);
    }
    return null;
  }
}