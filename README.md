#  pyimgui-colortextedit
A Python wrapper for [`ColorTextEdit`][gh_colortextedit] widget

## Requirements
- Cython >= 0.29.21

## Note
- We are not using the latest versions of `ColorTextEdit` and `imgui` since this wrapper is targeted to be compatiable with `pyimgui` which is still working on imgui v1.65.

- Most of the implementation in this wrapper follow the style/layout of `pyimgui`, but there are still something worth noting:

  - Since this wrapper is not developed directly under `pyimgui`, some internal states used by `imgui` won't be shared between the dll/so files built from `pyimgui` and this wrapper. (see also [this comment][imgui_context_sharing_desc])

  - To solve the above-mentioned issue, we have to access the context created by a main application running `pyimgui` by `get_current_context()`, then use `set_current_context()` to set the shared context going to be used by this wrapper. However, since we cannot access `cdef`ed attributes of a object wrapped by Python object, we have to rely on passing pointer as an argument to `set_current_context_ptr()` to achieve this goal.

  - Even though we can successfully get the `ImGuiContext` used by the main process, it still failed to render the `TextEditor`. See also issue #1.

[gh_colortextedit]: https://github.com/BalazsJako/ImGuiColorTextEdit
[imgui_context_sharing_desc]: https://github.com/ocornut/imgui/blob/7b1ab5b/imgui.cpp#L878-L898
