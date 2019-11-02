class FormController < XLFormViewController

  def init
    form = XLFormDescriptor.formDescriptor

    section = XLFormSectionDescriptor.formSectionWithTitle("Section A")
    form.addFormSection section

    row = XLFormRowDescriptor.formRowDescriptorWithTag(
      "switch",
      rowType: XLFormRowDescriptorTypeBooleanSwitch,
      title: "Show/Hide next field"
    )
    row.value = 0
    section.addFormRow row

    row = XLFormRowDescriptor.formRowDescriptorWithTag(
      "text",
      rowType: XLFormRowDescriptorTypeText,
      title: "Shown if previous field is on"
    )

    # --- FAIL ---
    # Simple const value assign
    # row.hidden = true

    # Simple const value assign via setHidden method call
    # row.setHidden(true)

    # Simple string for predicate creation
    # row.hidden = NSString.stringWithFormat "$%@==0", "switch"

    # Using an obj-c wrapper to call assign the same string
    # RMHelper.set_hidden({
    #   "control" => row,
    #   "hidden_value" => NSString.stringWithFormat("$%@==0", "switch")
    # })

    # Using an obj-c wrapper which sets hidden to false
    # RMHelper.hide_row(row)

    # --- WORK ---
    # New methods on XLFormDescriptor
    # row.setHiddenToPredicate
    # row.setHiddenToTrue
    # row.setHiddenToFalse

    section.addFormRow row

    super.initWithForm(form)
  end

end
