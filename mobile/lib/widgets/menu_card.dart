import 'package:flutter/material.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color? color;
  final VoidCallback onTap;
  final bool showTrailingIcon;
  final double iconSize;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;

  const MenuCard({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
    this.color,
    this.showTrailingIcon = true,
    this.iconSize = 24.0,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(16.0),
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = color ?? theme.primaryColor;
    final effectiveTextStyle =
        textStyle ??
        const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: onTap,
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          constraints: const BoxConstraints(minHeight: 60), // Altura mínima
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Parte esquerda com ícone e texto
              Flexible(
                child: Row(
                  children: [
                    if (icon != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, size: iconSize, color: primaryColor),
                      ),
                    Flexible(
                      child: Text(
                        title,
                        style: effectiveTextStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),

              // Ícone à direita
              if (showTrailingIcon)
                Icon(
                  Icons.chevron_right,
                  color: Colors.black54,
                  size: iconSize,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
