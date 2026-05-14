import 'package:flutter/material.dart';
import 'dart:ui';

class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double blurValue;
  final double opacity;
  final Color? color;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadius borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.blurValue = 10,
    this.opacity = 0.1,
    this.color,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.border,
    this.boxShadow,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultColor = isDark ? Colors.white : Colors.black;
    final containerColor = (color ?? defaultColor).withValues(alpha: opacity);

    return Container(
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  gradient: gradient,
                  color: containerColor,
                  borderRadius: borderRadius,
                  border: border ??
                      Border.all(
                        color: (isDark ? Colors.white : Colors.white)
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                  boxShadow: boxShadow ?? _defaultShadow(context),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BoxShadow> _defaultShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: (isDark ? Colors.black : Colors.black).withValues(alpha: 0.1),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }
}

class GlassmorphicButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final double blurValue;
  final bool isSmall;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;

  const GlassmorphicButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.blurValue = 8,
    this.isSmall = false,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        backgroundColor ?? color ?? Theme.of(context).colorScheme.primary;
    final textButtonColor = textColor ?? buttonColor;

    return GlassmorphicContainer(
      blurValue: blurValue,
      opacity: 0.15,
      color: buttonColor,
      borderRadius: BorderRadius.circular(isSmall ? 12 : 16),
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 12 : 20,
        vertical: isSmall ? 8 : 14,
      ),
      onTap: isLoading || onPressed == null ? null : onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            SizedBox(
              width: isSmall ? 12 : 16,
              height: isSmall ? 12 : 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(textButtonColor),
              ),
            )
          else if (icon != null) ...[
            Icon(
              icon,
              color: textButtonColor,
              size: isSmall ? 16 : 20,
            ),
          ],
          if (isLoading) const SizedBox(width: 8),
          if (!isLoading && icon != null) const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isLoading
                  ? textButtonColor.withValues(alpha: 0.7)
                  : textButtonColor,
              fontWeight: FontWeight.bold,
              fontSize: isSmall ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double blurValue;
  final Color? borderColor;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.blurValue = 12,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      blurValue: blurValue,
      opacity: 0.08,
      padding: padding,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      onTap: onTap,
      border: borderColor != null
          ? Border.all(color: borderColor!, width: 2)
          : null,
      child: child,
    );
  }
}

class GlassmorphicTextField extends StatefulWidget {
  final String labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType keyboardType;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final bool obscureText;

  const GlassmorphicTextField({
    super.key,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.controller,
    this.obscureText = false,
  });

  @override
  State<GlassmorphicTextField> createState() => _GlassmorphicTextFieldState();
}

class _GlassmorphicTextFieldState extends State<GlassmorphicTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GlassmorphicContainer(
      blurValue: 8,
      opacity: _isFocused ? 0.15 : 0.08,
      color: primaryColor,
      borderRadius: BorderRadius.circular(16),
      padding: EdgeInsets.zero,
      border: Border.all(
        color: _isFocused
            ? primaryColor.withValues(alpha: 0.5)
            : (isDark ? Colors.white : Colors.white).withValues(alpha: 0.2),
        width: _isFocused ? 2 : 1,
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          prefixIcon:
              widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
          suffixIcon:
              widget.suffixIcon != null ? Icon(widget.suffixIcon) : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: TextStyle(
            color: primaryColor.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}

class GlassmorphicAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double elevation;

  const GlassmorphicAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.elevation = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color:
                (isDark ? Colors.white : Colors.white).withValues(alpha: 0.1),
            border: Border(
              bottom: BorderSide(
                color: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: elevation,
            title: Text(title),
            actions: actions,
            leading: leading,
            centerTitle: centerTitle,
          ),
        ),
      ),
    );
  }
}
