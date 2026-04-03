import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────
class DropdownItem {
  final String label;
  final String value;

  const DropdownItem({required this.label, required this.value});
}

// ─────────────────────────────────────────────
// WIDGET
// ─────────────────────────────────────────────
class AutocompleteDropdown extends StatefulWidget {
  final List<DropdownItem> items;
  final String? label;
  final String? hint;
  final DropdownItem? initialValue;
  final void Function(DropdownItem selected)? onSelected;
  final String? Function(DropdownItem?)? validator;

  const AutocompleteDropdown({
    super.key,
    required this.items,
    this.label,
    this.hint,
    this.initialValue,
    this.onSelected,
    this.validator,
  });

  @override
  State<AutocompleteDropdown> createState() => _AutocompleteDropdownState();
}

class _AutocompleteDropdownState extends State<AutocompleteDropdown> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;
  List<DropdownItem> _filtered = [];
  DropdownItem? _selected;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _filtered = widget.items;
    if (widget.initialValue != null) {
      _selected = widget.initialValue;
      _controller.text = widget.initialValue!.label;
    }

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _openOverlay();
      } else {
        _closeOverlay();
        // Restore selected label if user typed something invalid
        if (_selected != null) {
          _controller.text = _selected!.label;
        } else {
          _controller.clear();
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  // ── Filtering ──────────────────────────────
  void _onTextChanged(String query) {
    setState(() {
      _selected = null;
      _filtered = query.isEmpty
          ? widget.items
          : widget.items
              .where((item) =>
                  item.label.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
    _overlayEntry?.markNeedsBuild();
  }

  // ── Selection ──────────────────────────────
  void _selectItem(DropdownItem item) {
    setState(() {
      _selected = item;
      _controller.text = item.label;
      _filtered = widget.items;
    });
    widget.onSelected?.call(item);
    _focusNode.unfocus();
    _closeOverlay();
  }

  void _onSubmitted(String value) {
    final lowerValue = value.trim().toLowerCase();
    if (lowerValue.isEmpty) return;

    for (final item in widget.items) {
      if (item.label.toLowerCase() == lowerValue) {
        _selectItem(item);
        break;
      }
    }
  }

  // ── Overlay ────────────────────────────────
  void _openOverlay() {
    if (_isOpen) return;
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  void _toggleOverlay() {
    if (_isOpen) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  OverlayEntry _buildOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 4),
          child: _DropdownOverlay(
            items: _filtered,
            selected: _selected,
            onSelect: _selectItem,
          ),
        ),
      ),
    );
  }

  // ── Build ───────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onTextChanged,
        onFieldSubmitted: _onSubmitted,
        validator: widget.validator != null
            ? (_) => widget.validator!(_selected)
            : null,
        decoration: InputDecoration(
          labelText: widget.label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: widget.hint ?? 'Book...',
          border: const OutlineInputBorder(),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Clear button
              if (_controller.text.isNotEmpty)
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.clear, size: 12),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _selected = null;
                      _filtered = widget.items;
                    });
                    _overlayEntry?.markNeedsBuild();
                    widget.onSelected?.call(
                      DropdownItem(label: '', value: ''),
                    );
                  },
                ),
              // Chevron toggle
              IconButton(
                icon: AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
                onPressed: _toggleOverlay,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// OVERLAY CONTENT
// ─────────────────────────────────────────────
class _DropdownOverlay extends StatelessWidget {
  final List<DropdownItem> items;
  final DropdownItem? selected;
  final void Function(DropdownItem) onSelect;

  const _DropdownOverlay({
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(8),
      color: theme.colorScheme.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 220),
        child: items.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'No results found',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = selected?.value == item.value;

                  return InkWell(
                    onTap: () => onSelect(item),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      color: isSelected
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : null,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.label,
                              style: TextStyle(
                                color: isSelected
                                    ? theme.colorScheme.primary
                                    : null,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          if (isSelected)
                            Icon(Icons.check,
                                size: 18, color: theme.colorScheme.primary),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
