
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/model/attendance_models.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/services/attendance_export_service.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/widgets/attendance_table.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/widgets/daily_attendance_filters.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/widgets/pagination_bar.dart';

import '../../../../../../core/errors/app_exception.dart';
import '../../data/model/attendance_record.dart';
import '../../data/services/attendance_import_service.dart';
import '../view_model/attendance_view_model.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _searchCtrl = TextEditingController();
  bool _exporting = false;

  DailyAttendanceCubit get _cubit => context.read<DailyAttendanceCubit>();

  @override
  void initState() {
    super.initState();
    _searchCtrl.text = _cubit.state.search;
    _cubit.load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _toast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? ColorManger.error : ColorManger.primary,
      textColor: ColorManger.white,
      fontSize: 14,
    );
  }

  Future<void> _export(DailyAttendanceState state, {required bool pdf}) async {
    if (_exporting) return;
    if (state.total == 0) {
      _toast('لا توجد بيانات للتصدير', isError: true);
      return;
    }
    setState(() => _exporting = true);
    try {
      final rows = await _cubit.fetchAllForExport();
      if (pdf) {
        await AttendanceExportService.exportPdf(rows: rows, date: state.date);
      } else {
        await AttendanceExportService.exportExcel(rows: rows, date: state.date);
      }
      _toast('تم التصدير بنجاح');
    } catch (_) {
      _toast('تعذر تصدير الملف', isError: true);
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  Future<void> _import() async {
    if (_exporting || _cubit.state.isSaving) return;

    try {
      final files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (files.isEmpty) return;

      final file = files.first;

      final ParsedImport parsed;

      try {
        final bytes = await file.readAsBytes();

        parsed = AttendanceImportService.parse(bytes);
      } on AppException catch (e) {
        _toast(e.message, isError: true);
        return;
      } catch (e) {
        _toast('تعذر قراءة الملف: $e', isError: true);
        return;
      }

      if (parsed.rows.isEmpty) {
        await _showImportSummary(
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

      final ok = await _confirm(
        'استيراد من ملف',
        'سيتم تسجيل $present حاضر، وحذف سجل حضور $absent غائب (لو موجود). متابعة؟',
        'استيراد',
        danger: absent > 0,
      );

      if (!ok || !mounted) return;

      final result = await _cubit.importRows(parsed.rows);

      if (result == null || !mounted) return;

      final errors = [...parsed.errors, ...result.errors]
        ..sort((a, b) => a.rowNumber.compareTo(b.rowNumber));

      await _showImportSummary(
        inserted: result.inserted,
        deleted: result.deleted,
        errors: errors,
      );
    } catch (e) {
      _toast('حدث خطأ أثناء استيراد الملف: $e', isError: true);
    }
  }  Future<void> _showImportSummary({
    required int inserted,
    required int deleted,
    required List<ImportError> errors,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: ColorManger.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: const Text('نتيجة الاستيراد'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('تم تسجيل حضور: $inserted'),
                Text('تم حذف سجل حضور (غياب): $deleted'),
                Text('صفوف فيها أخطاء: ${errors.length}'),
                if (errors.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (final e in errors)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              'صف ${e.rowNumber}: ${e.message}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: ColorManger.error,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('تم'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirm(
    String title,
    String message,
    String confirmText, {
    bool danger = false,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: ColorManger.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(
                confirmText,
                style: TextStyle(
                  color: danger ? ColorManger.error : ColorManger.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return ok == true;
  }

  Future<void> _pickDate(DateTime current) async {
    final picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorManger.primary,
              onPrimary: ColorManger.white,
              onSurface: ColorManger.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: ColorManger.primary),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: current,
      firstDate: DateTime(2008),
      lastDate: DateTime.now(),
    );
    if (picked != null && mounted) _cubit.applyFilters(date: picked);
  }

  Future<void> _pickTime(DailyAttendanceRow r, bool isCheckIn) async {
    final current = isCheckIn ? r.checkIn : r.checkOut;
    final fallback = isCheckIn ? r.scheduledIn : r.scheduledOut;

    final picked = await showTimePicker(
      context: context,
      initialTime:
          _parseTime(current) ??
          _parseTime(fallback) ??
          const TimeOfDay(hour: 9, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorManger.primary,
              onPrimary: ColorManger.white,
              onSurface: ColorManger.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: ColorManger.primary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked == null || !mounted) return;

    _cubit.editTime(
      r,
      isCheckIn,
      '${picked.hour.toString().padLeft(2, '0')}:'
      '${picked.minute.toString().padLeft(2, '0')}',
    );
  }

  TimeOfDay? _parseTime(String? s) {
    if (s == null) return null;
    final m = RegExp(
      r'^(\d{1,2}):(\d{2})\s*(AM|PM)?$',
      caseSensitive: false,
    ).firstMatch(s.trim());
    if (m == null) return null;
    var h = int.parse(m[1]!);
    final min = int.parse(m[2]!);
    final suffix = m[3]?.toUpperCase();
    if (suffix != null) {
      if (h == 12) h = 0;
      if (suffix == 'PM') h += 12;
    }
    return TimeOfDay(hour: h, minute: min);
  }

  Widget _exportButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
  }) => OutlinedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, size: 18),
    label: Text(label),
    style: OutlinedButton.styleFrom(
      foregroundColor: ColorManger.primary,
      side: const BorderSide(color: ColorManger.primary),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyAttendanceCubit, DailyAttendanceState>(
      listenWhen: (p, c) => c.notice != null && !identical(p.notice, c.notice),
      listener: (context, state) {
        final n = state.notice!;
        _toast(n.message, isError: n.isError);
      },
      builder: (context, state) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: ColorManger.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorManger.cardBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DailyAttendanceFilters(
                searchCtrl: _searchCtrl,
                date: state.date,
                filter: state.filter,
                isSaving: state.isSaving,
                canMarkAll: state.status == LoadStatus.ready,
                onPickDate: () => _pickDate(state.date),
                onFilterChanged: (f) => _cubit.applyFilters(filter: f),
                onSearch: () => _cubit.applyFilters(search: _searchCtrl.text),
                onMarkAll: () async {
                  if (await _confirm(
                    'تسجيل الكل حاضر',
                    'سيتم تسجيل كل الغايبين في هذه الصفحة حاضرين '
                        'بمواعيدهم الافتراضية. متابعة؟',
                    'تأكيد',
                  )) {
                    _cubit.markAllPresent();
                  }
                },
              ),
              const SizedBox(height: 12),
              if (state.status == LoadStatus.ready)
                Row(
                  children: [
                    Text(
                      'العدد: ${state.total}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: ColorManger.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    if (_exporting)
                      const Padding(
                        padding: EdgeInsetsDirectional.only(end: 12),
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ColorManger.primary,
                          ),
                        ),
                      ),
                    _exportButton(
                      label: 'استيراد',
                      icon: Icons.upload_file_outlined,
                      onPressed: (_exporting || state.isSaving)
                          ? null
                          : _import,
                    ),
                    const SizedBox(width: 8),
                    _exportButton(
                      label: 'Excel',
                      icon: Icons.table_chart_outlined,
                      onPressed: _exporting
                          ? null
                          : () => _export(state, pdf: false),
                    ),
                    const SizedBox(width: 8),
                    _exportButton(
                      label: 'PDF',
                      icon: Icons.picture_as_pdf_outlined,
                      onPressed: _exporting
                          ? null
                          : () => _export(state, pdf: true),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              if (state.status == LoadStatus.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorManger.primary,
                    ),
                  ),
                )
              else if (state.status == LoadStatus.failure)
                Center(
                  child: Column(
                    children: [
                      Text(state.notice?.message ?? 'حدث خطأ غير متوقع'),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'إعادة المحاولة',
                        onPressed: _cubit.load,
                      ),
                    ],
                  ),
                )
              else ...[
                AbsorbPointer(
                  absorbing: state.isSaving,
                  child: Opacity(
                    opacity: state.isSaving ? 0.6 : 1,
                    child: DailyAttendanceTable(
                      rows: state.rows,
                      onPresent: _cubit.markPresent,
                      onAbsent: (r) async {
                        if (await _confirm(
                          'تسجيل غياب',
                          'سيتم حذف سجل حضور ${r.employeeName} '
                              'لهذا اليوم. متابعة؟',
                          'حذف',
                          danger: true,
                        )) {
                          _cubit.markAbsent(r);
                        }
                      },
                      onEditTime: _pickTime,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PaginationBar(
                  currentPage: state.page + 1,
                  totalPages: state.totalPages,
                  onPageChanged: (p) => _cubit.goToPage(p - 1),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
