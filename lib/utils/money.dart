String formatMmk(num amount) => 'MMK ${amount.toStringAsFixed(0)}';

String formatMmkCents(int cents) => formatMmk(cents / 100);
