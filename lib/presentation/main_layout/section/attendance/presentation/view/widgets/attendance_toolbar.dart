import 'package:flutter/material.dart';
import 'package:hr_project/core/resources/colors/color_manger.dart';

class AttendanceToolbar extends StatelessWidget {
  const AttendanceToolbar({
    super.key,
    required this.total,
    required this.exporting,
    required this.isSaving,
    required this.onImport,
    required this.onExportExcel,
    required this.onExportPdf,
  });

  final int total;
  final bool exporting;
  final bool isSaving;
  final VoidCallback onImport;
  final VoidCallback onExportExcel;
  final VoidCallback onExportPdf;

  static const double _mobileBreakpoint = 700;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final isMobile = c.maxWidth < _mobileBreakpoint;

        final count = Text(
          'العدد: $total',
          style: const TextStyle(fontSize: 13, color: ColorManger.textPrimary),
        );

        final spinner = exporting
            ? const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: ColorManger.primary,
          ),
        )
            : null;

        final importBtn = _ActionButton(
          label: 'استيراد',
          icon: Icons.upload_file_outlined,
          onPressed: (exporting || isSaving) ? null : onImport,
        );
        final excelBtn = _ActionButton(
          label: 'Excel',
          icon: Icons.table_chart_outlined,
          onPressed: exporting ? null : onExportExcel,
        );
        final pdfBtn = _ActionButton(
          label: 'PDF',
          icon: Icons.picture_as_pdf_outlined,
          onPressed: exporting ? null : onExportPdf,
        );

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  count,
                  const Spacer(),
                  ?spinner,
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: importBtn),
                  const SizedBox(width: 8),
                  Expanded(child: excelBtn),
                  const SizedBox(width: 8),
                  Expanded(child: pdfBtn),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            count,
            const Spacer(),
            if (spinner != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: spinner,
              ),
            importBtn,
            const SizedBox(width: 8),
            excelBtn,
            const SizedBox(width: 8),
            pdfBtn,
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: FittedBox(fit: BoxFit.scaleDown, child: Text(label)),
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorManger.primary,
        side: const BorderSide(color: ColorManger.primary),
        padding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}