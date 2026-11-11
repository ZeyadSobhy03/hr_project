import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/data/model/attendance_models.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/helpers/attendance_dialogs.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/helpers/attendance_io_flow.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/helpers/attendance_pickers.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/helpers/attendance_toast_helper.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/widgets/attendance_table.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/widgets/attendance_toolbar.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/widgets/daily_attendance_filters.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/widgets/pagination_bar.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view_model/attendance_view_model.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  static const double _mobileBreakpoint = 700;

  final _searchCtrl = TextEditingController();
  bool _busy = false;

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

  Future<void> _export(DailyAttendanceState state, {required bool pdf}) async {
    if (_busy) return;
    if (state.total == 0) {
      AttendanceToastHelper.show('لا توجد بيانات للتصدير', isError: true);
      return;
    }
    setState(() => _busy = true);
    try {
      await AttendanceIoFlow.export(_cubit, state, pdf: pdf);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _import() async {
    if (_busy || _cubit.state.isSaving) return;
    await AttendanceIoFlow.import(context, _cubit);
  }

  Future<void> _pickDate(DateTime current) async {
    final picked = await AttendancePickers.pickDate(context, current);
    if (picked != null && mounted) _cubit.applyFilters(date: picked);
  }

  Future<void> _pickTime(DailyAttendanceRow r, bool isCheckIn) async {
    final time = await AttendancePickers.pickTime(context, r, isCheckIn);
    if (time != null && mounted) _cubit.editTime(r, isCheckIn, time);
  }

  Future<void> _markAllPresent() async {
    final ok = await AttendanceDialogs.confirm(
      context,
      title: 'تسجيل الكل حاضر',
      message:
      'سيتم تسجيل كل الغايبين في هذه الصفحة حاضرين '
          'بمواعيدهم الافتراضية. متابعة؟',
      confirmText: 'تأكيد',
    );
    if (ok && mounted) _cubit.markAllPresent();
  }

  Future<void> _markAbsent(DailyAttendanceRow r) async {
    final ok = await AttendanceDialogs.confirm(
      context,
      title: 'تسجيل غياب',
      message: 'سيتم حذف سجل حضور ${r.employeeName} لهذا اليوم. متابعة؟',
      confirmText: 'حذف',
      danger: true,
    );
    if (ok && mounted) _cubit.markAbsent(r);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyAttendanceCubit, DailyAttendanceState>(
      listenWhen: (p, c) => c.notice != null && !identical(p.notice, c.notice),
      listener: (context, state) {
        final n = state.notice!;
        AttendanceToastHelper.show(n.message, isError: n.isError);
      },
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < _mobileBreakpoint;

            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(isMobile ? 12 : 20),
              decoration: BoxDecoration(
                color: ColorManger.card,
                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                border: Border.all(color: ColorManger.cardBorder),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DailyAttendanceFilters(
                    searchCtrl: _searchCtrl,
                    date: state.date,
                    filter: state.filter,
                    isSaving: state.isSaving,
                    canMarkAll: state.status == LoadStatus.ready,
                    onPickDate: () => _pickDate(state.date),
                    onFilterChanged: (f) => _cubit.applyFilters(filter: f),
                    onSearch: () =>
                        _cubit.applyFilters(search: _searchCtrl.text),
                    onMarkAll: _markAllPresent,
                  ),
                  const SizedBox(height: 12),
                  if (state.status == LoadStatus.ready)
                    AttendanceToolbar(
                      total: state.total,
                      exporting: _busy,
                      isSaving: state.isSaving,
                      onImport: _import,
                      onExportExcel: () => _export(state, pdf: false),
                      onExportPdf: () => _export(state, pdf: true),
                    ),
                  const SizedBox(height: 8),
                  _buildBody(state, isMobile, constraints.maxWidth),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBody(
      DailyAttendanceState state,
      bool isMobile,
      double availableWidth,
      ) {
    switch (state.status) {
      case LoadStatus.loading:
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 48),
          child: Center(
            child: CircularProgressIndicator(color: ColorManger.primary),
          ),
        );
      case LoadStatus.failure:
        return Center(
          child: Column(
            children: [
              Text(state.notice?.message ?? 'حدث خطأ غير متوقع'),
              const SizedBox(height: 16),
              CustomButton(text: 'إعادة المحاولة', onPressed: _cubit.load),
            ],
          ),
        );
      default:
      // الجدول نفسه بيتحول لكروت على الموبايل.
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AbsorbPointer(
              absorbing: state.isSaving,
              child: Opacity(
                opacity: state.isSaving ? 0.6 : 1,
                child: DailyAttendanceTable(
                  rows: state.rows,
                  onPresent: _cubit.markPresent,
                  onAbsent: _markAbsent,
                  onEditTime: _pickTime,
                ),
              ),
            ),
            SizedBox(height: isMobile ? 12 : 20),
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: PaginationBar(
                    currentPage: state.page + 1,
                    totalPages: state.totalPages,
                    onPageChanged: (p) => _cubit.goToPage(p - 1),
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }
}