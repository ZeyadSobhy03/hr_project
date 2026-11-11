import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';
import 'package:hr_project/core/resources/widgets/custom_button.dart';
import 'package:hr_project/presentation/main_layout/section/attendance/presentation/view/widgets/pagination_bar.dart';
import 'package:hr_project/presentation/main_layout/section/salary_reports/presentaion/view/widgets/salary_filters.dart';
import 'package:hr_project/presentation/main_layout/section/salary_reports/presentaion/view/widgets/salary_table.dart';

import '../../../../../../core/errors/app_exception.dart';
import '../../data/models/salary_record.dart';
import '../../data/services/salary_export_service.dart';
import '../view_model/salary_reports_view_model.dart';

class SalaryReports extends StatefulWidget {
  const SalaryReports({super.key});

  @override
  State<SalaryReports> createState() => _SalaryReportsState();
}

class _SalaryReportsState extends State<SalaryReports> {
  static const _months = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  late final List<String> _years = [
    for (var year = 2008; year <= DateTime.now().year; year++) '$year',
  ];

  final _searchCtrl = TextEditingController();
  late String? _month = _months[DateTime.now().month - 1];
  late String? _year = '${DateTime.now().year}';
  bool _exporting = false;

  SalaryReportsCubit get _cubit => context.read<SalaryReportsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final monthIndex = _months.indexOf(_month ?? '');
    final year = int.tryParse(_year ?? '');
    if (monthIndex < 0 || year == null) return;
    await _cubit.applyFilters(
      year: year,
      month: monthIndex + 1,
      search: _searchCtrl.text,
    );
  }

  void _snack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? ColorManger.error : ColorManger.primary,
      ),
    );
  }

  Future<void> _export(SalaryReportsState state, {required bool pdf}) async {
    if (_exporting) return;
    if (state.total == 0) {
      _snack('لا توجد بيانات للتصدير', isError: true);
      return;
    }
    setState(() => _exporting = true);
    try {
      final records = await _cubit.fetchAllForExport();
      if (pdf) {
        await SalaryExportService.exportPdf(
          records: records,
          year: state.year,
          month: state.month,
          monthName: _months[state.month - 1],
        );
      } else {
        await SalaryExportService.exportExcel(
          records: records,
          year: state.year,
          month: state.month,
        );
      }
      if (mounted) _snack('تم التصدير بنجاح');
    } on AppException catch (e) {
      if (mounted) _snack(e.message, isError: true);
    } catch (_) {
      if (mounted) _snack('تعذر تصدير الملف', isError: true);
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  void _showDetails(SalaryRecord record) {
    String amount(num value) =>
        value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColorManger.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text('مفردات الراتب'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('الموظف: ${record.employeeName}'),
              Text('القسم: ${record.department}'),
              const Divider(height: 24),
              _detail('الراتب الأساسي', amount(record.baseSalary)),
              _detail('أيام الحضور', '${record.attendanceDays}'),
              _detail('أيام الغياب', '${record.absenceDays}'),
              _detail('ساعات الإضافي', amount(record.overtimeHours)),
              _detail('ساعات التأخير', amount(record.deductionHours)),
              _detail('قيمة الإضافي', amount(record.totalOvertime)),
              _detail('إجمالي الخصم', amount(record.totalDeduction)),
              const Divider(height: 24),
              _detail('صافي الراتب', amount(record.netSalary), bold: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إغلاق',
              style: TextStyle(color: ColorManger.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detail(String label, String value, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(
          value,
          style: TextStyle(fontWeight: bold ? FontWeight.w700 : null),
        ),
      ],
    ),
  );

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

  Widget _exportBar(SalaryReportsState state) => Row(
    children: [
      Text(
        'العدد: ${state.total}',
        style: const TextStyle(fontSize: 13, color: ColorManger.textPrimary),
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
        label: 'Excel',
        icon: Icons.table_chart_outlined,
        onPressed: _exporting ? null : () => _export(state, pdf: false),
      ),
      const SizedBox(width: 8),
      _exportButton(
        label: 'PDF',
        icon: Icons.picture_as_pdf_outlined,
        onPressed: _exporting ? null : () => _export(state, pdf: true),
      ),
    ],
  );

  Widget _forbidden() => const Center(
    child: Padding(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline, size: 48, color: ColorManger.primary),
          SizedBox(height: 12),
          Text('ليس لديك صلاحية عرض تقرير الرواتب'),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SalaryReportsCubit, SalaryReportsState>(
      listenWhen: (previous, current) =>
      current.notice != null && current.notice != previous.notice,
      listener: (context, state) {
        _snack(state.notice!, isError: state.isError);
      },
      builder: (context, state) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorManger.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorManger.cardBorder),
        ),
        child: state.forbidden
            ? _forbidden()
            : Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SalaryFilters(
              searchCtrl: _searchCtrl,
              months: _months,
              years: _years,
              month: _month,
              year: _year,
              onMonthChanged: (value) => setState(() => _month = value),
              onYearChanged: (value) => setState(() => _year = value),
              onSearch: _search,
            ),
            const SizedBox(height: 20),
            if (state.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(
                    color: ColorManger.primary,
                  ),
                ),
              )
            else if (state.isError && state.records.isEmpty)
              Center(
                child: Column(
                  children: [
                    Text(state.notice ?? 'تعذر تحميل تقرير الرواتب'),
                    const SizedBox(height: 12),
                    CustomButton(
                      text: 'إعادة المحاولة',
                      onPressed: _cubit.load,
                    ),
                  ],
                ),
              )
            else ...[
                _exportBar(state),
                const SizedBox(height: 12),
                SalaryTable(
                  records: state.records,
                  onDetails: _showDetails,
                ),
                const SizedBox(height: 16),
                PaginationBar(
                  currentPage: state.page + 1,
                  totalPages: state.totalPages,
                  onPageChanged: (page) => _cubit.goToPage(page - 1),
                ),
              ],
          ],
        ),
      ),
    );
  }
}