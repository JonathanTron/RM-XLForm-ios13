# Simple reproduction case for XLForm + RubyMotion failure on iOS 13.x

Compile with RM 6.5, XCode 11.2 and deploy to iOS 13.2 simulator.

The exact same behaviour appear as long as you try to *run* it on iOS 13.2,
no matter if you compile with XCode 10.3/iOS 12.4 then run on iOS 13.2, or if
we switch back to XLForm 3.3.0...

Example calls which fails are in `app/form_controller.rb`:

```
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

# Using an obj-c wrapper which sets hidden to true
# RMHelper.hide_row(row)

# --- WORK ---
# New method on XLFormDescriptor
# row.setHiddenFromRuby true
# row.setHiddenFromRuby "$switch==0"
# row.setHiddenFromRuby NSString.stringWithFormat("$%@==0", "switch")
```

Uncomment one of lines and run with:

```
rake simulator debug=1
```

When calling `row.hidden =` or `row.setHidden` from ruby it always fail with the
following backtrace:

```
1 location added to breakpoint 2
Process 2825 resuming
Process 2825 stopped
* thread #1, queue = 'com.apple.main-thread', stop reason = EXC_BAD_ACCESS (code=1, address=0x1)
    frame #0: 0x00007fff50bad357 libobjc.A.dylib`objc_retain + 7
libobjc.A.dylib`objc_retain:
->  0x7fff50bad357 <+7>:  movq   (%rdi), %rax
    0x7fff50bad35a <+10>: testb  $0x4, 0x20(%rax)
    0x7fff50bad35e <+14>: jne    0x7fff50bad378            ; objc_object::sidetable_retain()
    0x7fff50bad364 <+20>: movq   0x3911706d(%rip), %rsi    ; "retain"
Target 0: (xlform-ios13) stopped.

(lldb) thead backtrace
error: 'thead' is not a valid command.
(lldb) thread backtrace
* thread #1, queue = 'com.apple.main-thread', stop reason = EXC_BAD_ACCESS (code=1, address=0x1)
  * frame #0: 0x00007fff50bad357 libobjc.A.dylib`objc_retain + 7
    frame #1: 0x0000000100014b29 xlform-ios13`-[XLFormRowDescriptor setHidden:](self=<unavailable>, _cmd=<unavailable>, hidden=<unavailable>) at XLFormRowDescriptor.m:516 [opt]
    frame #2: 0x000000010003134c xlform-ios13`__unnamed_127 + 92
    frame #3: 0x0000000100149154 xlform-ios13`rb_vm_dispatch + 8100
    frame #4: 0x000000010002cf34 xlform-ios13`vm_dispatch + 1380
    frame #5: 0x000000010002fcbe xlform-ios13`rb_scope__init__(self=0x0000600000cb8c30) at form_controller.rb:28
```
