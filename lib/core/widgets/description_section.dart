import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/localization/l10n.dart';

/// Collapsible long text with an internal expanded state.
class DescriptionSection extends StatefulWidget {
  const DescriptionSection({
    super.key,
    required this.text,
    this.title,
    this.maxLength = 220,
    this.emptyMessage,
  });

  final String text;
  final String? title;
  final int maxLength;
  final String? emptyMessage;

  @override
  State<DescriptionSection> createState() => _DescriptionSectionState();
}

class _DescriptionSectionState extends State<DescriptionSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final text = widget.text.isEmpty
        ? (widget.emptyMessage ?? l10n.noDescriptionAvailable)
        : widget.text;

    final canExpand = text.length > widget.maxLength;
    final displayText = _expanded || !canExpand
        ? text
        : '${text.substring(0, widget.maxLength).trimRight()}…';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            displayText,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (canExpand)
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(_expanded ? l10n.showLess : l10n.showMore),
            ),
        ],
      ),
    );
  }
}
