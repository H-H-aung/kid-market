import 'package:flutter/material.dart';
import 'package:kids_mart/data/app_store.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});
  Future<void> _edit(BuildContext context, SavedAddress? current) async {
    final store = AppScope.of(context);
    var recipient = current?.recipient ?? store.name;
    var phone = current?.phone ?? '';
    var address = current?.address ?? '';
    final form = GlobalKey<FormState>();
    var saving = false;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              8,
              20,
              24 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Form(
              key: form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    current == null ? 'Add address' : 'Edit address',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    initialValue: recipient,
                    decoration: const InputDecoration(
                      labelText: 'Recipient name',
                    ),
                    onChanged: (v) => recipient = v,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter a name' : null,
                  ),
                  TextFormField(
                    initialValue: phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (v) => phone = v,
                    validator: (v) =>
                        !RegExp(
                          r'^\+?[\d\s()-]{7,20}$',
                        ).hasMatch(v?.trim() ?? '')
                        ? 'Enter a valid phone number'
                        : null,
                  ),
                  TextFormField(
                    initialValue: address,
                    decoration: const InputDecoration(
                      labelText: 'Full delivery address',
                    ),
                    minLines: 2,
                    maxLines: 4,
                    onChanged: (v) => address = v,
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Enter the full address'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: saving
                        ? null
                        : () async {
                            if (!form.currentState!.validate()) return;
                            setSheetState(() => saving = true);
                            final ok = await saveAction(
                              sheetContext,
                              () => store.saveAddress(
                                SavedAddress(
                                  id:
                                      current?.id ??
                                      DateTime.now().microsecondsSinceEpoch
                                          .toString(),
                                  recipient: recipient.trim(),
                                  phone: phone.trim(),
                                  address: address.trim(),
                                ),
                              ),
                            );
                            if (!sheetContext.mounted) return;
                            if (ok) {
                              Navigator.pop(sheetContext);
                            } else {
                              setSheetState(() => saving = false);
                            }
                          },
                    child: Text(saving ? 'Saving...' : 'Save address'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Saved addresses')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (store.addresses.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'No saved addresses yet. Add one for checkout.',
                textAlign: TextAlign.center,
              ),
            ),
          for (final address in store.addresses)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (store.defaultAddress?.id == address.id)
                      const Chip(label: Text('Default address')),
                    Text(address.summary, style: const TextStyle(height: 1.6)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        TextButton(
                          onPressed: () => _edit(context, address),
                          child: const Text('Edit'),
                        ),
                        if (store.defaultAddress?.id != address.id)
                          TextButton(
                            onPressed: () => saveAction(
                              context,
                              () => store.setDefaultAddress(address.id),
                            ),
                            child: const Text('Use for delivery'),
                          ),
                        TextButton(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete address?'),
                                content: Text(address.address),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Keep'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true && context.mounted) {
                              await saveAction(
                                context,
                                () => store.removeAddress(address.id),
                              );
                            }
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => _edit(context, null),
            icon: const Icon(Icons.add),
            label: const Text('Add address'),
          ),
        ],
      ),
    );
  }
}
