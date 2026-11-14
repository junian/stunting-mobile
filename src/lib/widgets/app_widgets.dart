import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../helper/Branding.dart';
import '../theme/app_theme.dart';
import '../widget/AppPhoto.dart';

/// Bottom inset of the physical display, independent of the insets a
/// [Scaffold] removes from its `bottomNavigationBar` subtree.
double systemBottomInset(BuildContext context) {
  final viewInset = View.of(context).viewPadding.bottom /
      MediaQuery.devicePixelRatioOf(context);
  final mediaInset = MediaQuery.paddingOf(context).bottom;
  return viewInset > mediaInset ? viewInset : mediaInset;
}

/// Palette used by the small status pills and soft action tiles.
enum AppTone { primary, mint, amber, coral, neutral }

extension AppToneColors on AppTone {
  Color get foreground {
    switch (this) {
      case AppTone.primary:
        return AppColors.primaryDeep;
      case AppTone.mint:
        return AppColors.mint;
      case AppTone.amber:
        return AppColors.amber;
      case AppTone.coral:
        return AppColors.coral;
      case AppTone.neutral:
        return AppColors.inkSoft;
    }
  }

  Color get background {
    switch (this) {
      case AppTone.primary:
        return AppColors.primarySoft;
      case AppTone.mint:
        return AppColors.mintSoft;
      case AppTone.amber:
        return AppColors.amberSoft;
      case AppTone.coral:
        return AppColors.coralSoft;
      case AppTone.neutral:
        return AppColors.surfaceAlt;
    }
  }
}

/// Wraps a tap target with a subtle scale + haptic response. Using one
/// interaction language everywhere makes the app feel snappy and physical.
class AnimatedPressable extends StatefulWidget {
  const AnimatedPressable({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.97,
    this.haptic = true,
    this.behavior = HitTestBehavior.opaque,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final bool haptic;
  final HitTestBehavior behavior;

  @override
  State<AnimatedPressable> createState() => _AnimatedPressableState();
}

class _AnimatedPressableState extends State<AnimatedPressable> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!mounted || _pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: widget.onTap == null ? null : (_) => _setPressed(true),
      onTapCancel: widget.onTap == null ? null : () => _setPressed(false),
      onTapUp: widget.onTap == null
          ? null
          : (_) {
              _setPressed(false);
              if (widget.haptic) HapticFeedback.selectionClick();
              widget.onTap?.call();
            },
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Standard white surface used by every card in the app.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.margin,
    this.onTap,
    this.color,
    this.borderColor,
    this.gradient,
    this.shadow = true,
    this.radius = AppRadius.xl,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final Gradient? gradient;
  final bool shadow;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? AppColors.surface) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor ?? AppColors.line),
        boxShadow: shadow ? AppShadows.card : null,
      ),
      child: child,
    );

    if (onTap == null) return content;

    return AnimatedPressable(
      onTap: onTap,
      child: content,
    );
  }
}

/// Primary/secondary button with a built-in loading state.
enum AppButtonVariant { primary, soft, outline, mint, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.iconAfter = false,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.expand = true,
    this.height = 56,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool iconAfter;
  final AppButtonVariant variant;
  final bool loading;
  final bool expand;
  final double height;

  bool get _enabled => onPressed != null && !loading;

  @override
  Widget build(BuildContext context) {
    late final Gradient? gradient;
    late final Color background;
    late final Color foreground;
    late final Color? border;
    late final List<BoxShadow>? shadows;

    switch (variant) {
      case AppButtonVariant.primary:
        gradient = AppColors.brandGradient;
        background = AppColors.primary;
        foreground = Colors.white;
        border = null;
        shadows = _enabled ? AppShadows.primary : null;
        break;
      case AppButtonVariant.mint:
        gradient = AppColors.mintGradient;
        background = AppColors.mint;
        foreground = Colors.white;
        border = null;
        shadows = _enabled
            ? [
                BoxShadow(
                  color: AppColors.mint.withValues(alpha: 0.28),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : null;
        break;
      case AppButtonVariant.soft:
        gradient = null;
        background = AppColors.primarySoft;
        foreground = AppColors.primaryDeep;
        border = null;
        shadows = null;
        break;
      case AppButtonVariant.outline:
        gradient = null;
        background = AppColors.surface;
        foreground = AppColors.ink;
        border = AppColors.lineStrong;
        shadows = null;
        break;
      case AppButtonVariant.danger:
        gradient = null;
        background = AppColors.coralSoft;
        foreground = AppColors.coral;
        border = null;
        shadows = null;
        break;
    }

    final borderRadius = BorderRadius.circular(AppRadius.md + 2);
    final textStyle = TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontSize: 15.5,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
      color: _enabled ? foreground : foreground.withValues(alpha: 0.55),
    );

    Widget labelWidget = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );

    if (icon != null) {
      final iconWidget = Icon(
        icon,
        size: 20,
        color: _enabled ? foreground : foreground.withValues(alpha: 0.55),
      );
      labelWidget = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!iconAfter) ...[iconWidget, const SizedBox(width: 10)],
          Flexible(child: labelWidget),
          if (iconAfter) ...[const SizedBox(width: 10), iconWidget],
        ],
      );
    }

    if (loading) {
      labelWidget = SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.4,
          valueColor: AlwaysStoppedAnimation<Color>(foreground),
        ),
      );
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: _enabled ? 1 : 0.65,
      child: SizedBox(
        width: expand ? double.infinity : null,
        height: height,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null ? background : null,
              borderRadius: borderRadius,
              border: border == null ? null : Border.all(color: border),
              boxShadow: shadows,
            ),
            child: InkWell(
              onTap: _enabled ? onPressed : null,
              borderRadius: borderRadius,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(child: labelWidget),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Soft circular icon button, used in headers and toolbars.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 44,
    this.background = AppColors.surface,
    this.foreground = AppColors.ink,
    this.border,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color background;
  final Color foreground;
  final Color? border;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final button = AnimatedPressable(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: border == null ? null : Border.all(color: border!),
        ),
        child: Icon(icon, size: size * 0.46, color: foreground),
      ),
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.onTap,
    this.background = AppColors.surface,
    this.foreground = AppColors.ink,
  });

  final VoidCallback? onTap;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: Icons.arrow_back_rounded,
      background: background,
      foreground: foreground,
      onTap: onTap ?? () => Get.back(),
    );
  }
}

/// Gradient hero header with a soft decorative pattern.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    required this.child,
    this.gradient = AppColors.brandGradient,
    this.bottomRadius = 32,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 28),
  });

  final Widget child;
  final Gradient gradient;
  final double bottomRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.vertical(bottom: Radius.circular(bottomRadius)),
      child: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Stack(
          children: [
            Positioned(
              top: -70,
              right: -50,
              child: _Glow(
                size: 200,
                color: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            Positioned(
              bottom: -90,
              left: -60,
              child: _Glow(
                size: 210,
                color: AppColors.teal.withValues(alpha: 0.28),
              ),
            ),
            Positioned(
              top: 40,
              right: 90,
              child: _Glow(
                size: 44,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            SafeArea(
              // A header never owns the bottom inset; the page beneath it
              // handles the navigation bar and floating bottom bar.
              bottom: false,
              child: Padding(padding: padding, child: child),
            ),
          ],
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// Compact page header for inner screens: back button + title + action.
class AppPageHeader extends StatelessWidget {
  const AppPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.action,
    this.padding = const EdgeInsets.fromLTRB(20, 8, 20, 12),
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? action;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    // Inner pages are light; make sure status-bar icons stay legible even when
    // the previous route had a dark gradient behind them.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    });

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            AppBackButton(onTap: onBack),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
            if (action != null) ...[const SizedBox(width: 12), action!],
          ],
        ),
      ),
    );
  }
}

/// Section title with an optional "See all" action.
class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.padding = EdgeInsets.zero,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(actionLabel!),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Small rounded label, e.g. growth status or vaccination state.
class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.tone = AppTone.neutral,
    this.icon,
    this.dense = false,
  });

  final String label;
  final AppTone tone;
  final IconData? icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 9 : 11,
        vertical: dense ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: dense ? 12 : 14, color: tone.foreground),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: dense ? 11 : 12,
                fontWeight: FontWeight.w700,
                color: tone.foreground,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Photo with a graceful fallback, used for children and parents.
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.photo,
    this.name,
    this.size = 52,
    this.ring = false,
    this.icon = Icons.child_care_rounded,
    this.gradient = AppColors.brandGradient,
  });

  final String? photo;
  final String? name;
  final double size;
  final bool ring;
  final IconData icon;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: name != null && name!.trim().isNotEmpty
          ? Text(
              name!.trim().substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: size * 0.4,
                fontWeight: FontWeight.w700,
              ),
            )
          : Icon(icon, color: Colors.white, size: size * 0.5),
    );

    final image = photo == null || photo!.isEmpty
        ? fallback
        : ClipOval(
            child: AppPhoto(
              photo!,
              width: size,
              height: size,
              fit: BoxFit.cover,
            ),
          );

    if (!ring) return SizedBox(width: size, height: size, child: image);

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.75),
          width: 2,
        ),
      ),
      child: SizedBox(width: size, height: size, child: image),
    );
  }
}

/// Label + field + inline error, the shared form building block.
class AppField extends StatelessWidget {
  const AppField({
    super.key,
    required this.label,
    required this.child,
    this.required = false,
    this.helper,
    this.error,
    this.trailing,
  });

  final String label;
  final Widget child;
  final bool required;
  final String? helper;
  final String? error;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
            if (required)
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coral,
                ),
              ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 8),
        child,
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 6),
            child: Row(
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 13,
                  color: AppColors.coral,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    error!,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.coral,
                    ),
                  ),
                ),
              ],
            ),
          )
        else if (helper != null && helper!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 6),
            child: Text(
              helper!,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                color: AppColors.inkMuted,
                height: 1.4,
              ),
            ),
          ),
      ],
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.error,
    this.helper,
    this.required = false,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixText,
    this.maxLines = 1,
    this.minLines,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.textInputAction,
    this.autofocus = false,
    this.enabled = true,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final String? error;
  final String? helper;
  final bool required;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final String? suffixText;
  final int maxLines;
  final int? minLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool enabled;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return AppField(
      label: label,
      required: required,
      error: error,
      helper: helper,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        minLines: minLines,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        textInputAction: textInputAction,
        autofocus: autofocus,
        enabled: enabled,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
          height: 1.35,
        ),
        decoration: InputDecoration(
          hintText: hint,
          errorText: null,
          prefixIcon: prefixIcon == null
              ? null
              : Icon(prefixIcon, size: 20, color: AppColors.inkMuted),
          suffixText: suffixText,
          suffixStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.inkMuted,
          ),
        ),
      ),
    );
  }
}

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.error,
    this.helper,
    this.required = false,
  });

  final String label;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final String? error;
  final String? helper;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return AppField(
      label: label,
      required: required,
      error: error,
      helper: helper,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        items: items,
        onChanged: onChanged,
        isExpanded: true,
        icon: const Icon(Icons.expand_more_rounded, color: AppColors.inkMuted),
        hint: hint == null
            ? null
            : Text(
                hint!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.inkMuted,
                ),
              ),
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.ink,
        ),
        dropdownColor: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        decoration: const InputDecoration(errorText: null),
      ),
    );
  }
}

class AppSegment<T> {
  const AppSegment({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

/// Two/three-way selector with an animated sliding highlight.
class AppSegmented<T> extends StatelessWidget {
  const AppSegmented({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.error,
  });

  final List<AppSegment<T>> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              for (final option in options)
                Expanded(
                  child: _SegmentButton(
                    segment: option,
                    selected: option.value == value,
                    onTap: () => onChanged(option.value),
                  ),
                ),
            ],
          ),
        ),
        if (error != null && error!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, top: 6),
            child: Text(
              error!,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: AppColors.coral,
              ),
            ),
          ),
      ],
    );
  }
}

class _SegmentButton<T> extends StatelessWidget {
  const _SegmentButton({
    required this.segment,
    required this.selected,
    required this.onTap,
  });

  final AppSegment<T> segment;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected ? AppColors.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.ink.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (segment.icon != null) ...[
                  Icon(
                    segment.icon,
                    size: 16,
                    color: selected ? AppColors.primary : AppColors.inkMuted,
                  ),
                  const SizedBox(width: 6),
                ],
                Flexible(
                  child: Text(
                    segment.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: selected ? AppColors.ink : AppColors.inkSoft,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Icon + label + value tile used for growth measurements.
class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.unit,
    this.tone = AppTone.primary,
    this.compact = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? unit;
  final AppTone tone;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 12 : 14),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: compact ? 10.5 : 11.5,
                    fontWeight: FontWeight.w600,
                    color: tone.foreground.withValues(alpha: 0.9),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: compact ? 24 : 28,
                height: compact ? 24 : 28,
                decoration: BoxDecoration(
                  color: tone.foreground.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: compact ? 13 : 15,
                  color: tone.foreground,
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? 10 : 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: compact ? 19 : 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                    height: 1,
                    color: AppColors.ink,
                  ),
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 3),
                Text(
                  unit!,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Rounded progress bar with an optional gradient fill.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.mint,
    this.gradient,
    this.height = 8,
    this.background = AppColors.surfaceAlt,
  });

  final double value;
  final Color color;
  final Gradient? gradient;
  final double height;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: Container(
        height: height,
        color: background,
        child: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedFractionallySizedBox(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
            widthFactor: clamped == 0 ? 0.001 : clamped,
            child: Container(
              decoration: BoxDecoration(
                color: gradient == null ? color : null,
                gradient: gradient,
                borderRadius: BorderRadius.circular(height),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// White rounded tile used in settings and forms.
class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.tone = AppTone.primary,
    this.isLast = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final AppTone tone;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: tone.background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, size: 20, color: tone.foreground),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else if (onTap != null)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.inkMuted,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.tone = AppTone.primary,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final AppTone tone;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                color: tone.background,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 42, color: tone.foreground),
            ),
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: AppButton(
                  label: actionLabel!,
                  onPressed: onAction,
                  icon: Icons.add_rounded,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Lightweight skeleton placeholder with a gentle pulsing opacity.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.radius = 10,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.45, end: 0.95).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      ),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.line,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

/// A simple, dependency-free sparkline. Draws a smooth line and a soft fill.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.values,
    this.color = AppColors.primary,
    this.height = 64,
    this.lineWidth = 2.4,
    this.showDots = true,
    this.fillOpacity = 0.18,
  });

  final List<double> values;
  final Color color;
  final double height;
  final double lineWidth;
  final bool showDots;
  final double fillOpacity;

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            '—',
            style: TextStyle(color: AppColors.inkMuted.withValues(alpha: 0.7)),
          ),
        ),
      );
    }
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparklinePainter(
          values: values,
          color: color,
          lineWidth: lineWidth,
          showDots: showDots,
          fillOpacity: fillOpacity,
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({
    required this.values,
    required this.color,
    required this.lineWidth,
    required this.showDots,
    required this.fillOpacity,
  });

  final List<double> values;
  final Color color;
  final double lineWidth;
  final bool showDots;
  final double fillOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range =
        (maxValue - minValue).abs() < 0.0001 ? 1.0 : (maxValue - minValue);
    const padding = 6.0;

    final points = <Offset>[];
    for (var index = 0; index < values.length; index++) {
      final x = values.length == 1
          ? size.width / 2
          : padding + (size.width - padding * 2) * index / (values.length - 1);
      final normalized = (values[index] - minValue) / range;
      final y = padding + (size.height - padding * 2) * (1 - normalized);
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 0; index < points.length - 1; index++) {
      final current = points[index];
      final next = points[index + 1];
      final midX = (current.dx + next.dx) / 2;
      path.cubicTo(midX, current.dy, midX, next.dy, next.dx, next.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color.withValues(alpha: fillOpacity),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = lineWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    if (showDots) {
      final last = points.last;
      canvas.drawCircle(last, 4, Paint()..color = Colors.white);
      canvas.drawCircle(
        last,
        4,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.color != color ||
        oldDelegate.lineWidth != lineWidth;
  }
}

/// Shared bottom sheet scaffold with a title and optional action.
class AppSheet extends StatelessWidget {
  const AppSheet({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.action,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            subtitle!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
                if (action != null) action!,
              ],
            ),
            const SizedBox(height: 18),
            child,
          ],
        ),
      ),
    );
  }
}

/// Modern confirmation dialog used for destructive actions.
Future<bool?> showAppConfirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String? cancelLabel,
  bool destructive = true,
  IconData icon = Icons.delete_outline_rounded,
}) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        icon: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: destructive ? AppColors.coralSoft : AppColors.primarySoft,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: destructive ? AppColors.coral : AppColors.primary,
          ),
        ),
        title: Text(title, textAlign: TextAlign.center),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(dialogContext).textTheme.bodyMedium,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(
                    cancelLabel ?? 'cancel'.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        destructive ? AppColors.coral : AppColors.primary,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: Text(
                    confirmLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}

/// Consistent snackbars so errors never look like raw framework output.
class AppSnack {
  AppSnack._();

  static void success(String message) => _show(
        title: 'success'.tr,
        message: message,
        tone: AppTone.mint,
        icon: Icons.check_circle_rounded,
      );

  static void error(String message) => _show(
        title: 'warning'.tr,
        message: message,
        tone: AppTone.coral,
        icon: Icons.error_rounded,
      );

  static void info(String message) => _show(
        title: kAppName,
        message: message,
        tone: AppTone.primary,
        icon: Icons.info_rounded,
      );

  static void _show({
    required String title,
    required String message,
    required AppTone tone,
    required IconData icon,
  }) {
    if (Get.context == null) return;
    Get.snackbar(
      '',
      '',
      titleText: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: tone.background,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 17, color: tone.foreground),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      messageText: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Text(
          message,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            height: 1.4,
          ),
        ),
      ),
      backgroundColor: AppColors.ink,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 18,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
    );
  }
}
