# distutils: language = c++
# distutils: sources = imgui-cpp/imgui.cpp imgui-cpp/imgui_draw.cpp imgui-cpp/imgui_widgets.cpp imgui-colortextedit-cpp/TextEditor.cpp
# distutils: include_dirs = imgui-cpp imgui-colortextedit-cpp
# cython: embedsignature=False
import cython
from cython.operator cimport dereference as deref

from cpython.version cimport PY_MAJOR_VERSION

from libcpp cimport bool
from libcpp.cast cimport static_cast, reinterpret_cast
from libc.stdint cimport uintptr_t

cimport ctextedit

# XXX: Declare types for pointer since the template argument used by `reinterpret_cast`
# cannot be a statement of pointer (`TYPE*`), and it will be used to cast a Python integer
# object into a C pointer. This might not be a good solution for accessing address of C
# object, but since we cannot access the real address of `ImGuiContext` through the
# returned value of `get_current_context()`, this is currently the only workable workaround.
# (because the returned value will be always wrapped as a Python object, so that the
# *cdefed* attribute `_ptr` won't be accessible from Python)
# See also the following link for the reason why we have to do this:
# - https://github.com/ocornut/imgui/blob/7b1ab5b/imgui.cpp#L878-L898
ctypedef ctextedit.ImGuiContext* ImGuiContext_ptr
ctypedef long* long_ptr


cdef bytes _bytes(str text):
    return <bytes>(text if PY_MAJOR_VERSION < 3 else text.encode('utf-8'))


cdef ctextedit.ImVec2 _cast_args_ImVec2(float x, float y) except *:
    cdef ctextedit.ImVec2 vec
    vec.x, vec.y = x, y
    return vec


cdef class _ImGuiContext(object):
    cdef ctextedit.ImGuiContext* _ptr

    @staticmethod
    cdef from_ptr(ctextedit.ImGuiContext* ptr):
        if ptr == NULL:
            return None

        instance = _ImGuiContext()
        instance._ptr = ptr
        return instance

    def __eq__(_ImGuiContext self, _ImGuiContext other):
        return other._ptr == self._ptr


def get_current_context():
    cdef ctextedit.ImGuiContext* _ptr
    _ptr = ctextedit.GetCurrentContext()
    return _ImGuiContext.from_ptr(_ptr)


def get_current_context_ptr():
    """Get pointer of `ImGuiContext` instance."""
    cdef ctextedit.ImGuiContext* _ptr
    _ptr = ctextedit.GetCurrentContext()
    return <uintptr_t>_ptr


def set_current_context(_ImGuiContext ctx):
    ctextedit.SetCurrentContext(ctx._ptr)


def set_current_context_from_ptr(long ptr):
    """Set `ImGuiContext` by given pointer (it's actually a Python integer object)."""
    cdef long* temp_ptr
    cdef ctextedit.ImGuiContext* context_ptr
    cdef _ImGuiContext context

    # Cast integer into pointer
    temp_ptr = reinterpret_cast[long_ptr](<void *>ptr)
    context_ptr = reinterpret_cast[ImGuiContext_ptr](temp_ptr)

    context = _ImGuiContext.from_ptr(context_ptr)
    set_current_context(context)


cdef class TextEditor(object):
    cdef ctextedit.TextEditor* _ptr
    cdef bool _owner

    def __cinit__(self):
        self._ptr = NULL
        self._owner = False

    def __dealloc__(self):
        if self._owner:
            del self._ptr
            self._ptr = NULL

    @staticmethod
    def create():
        return TextEditor._create()

    @staticmethod
    cdef TextEditor from_ref(ctextedit.TextEditor& ref):
        cdef TextEditor instance = TextEditor()
        instance._ptr = &ref
        return instance

    @staticmethod
    cdef TextEditor _create():
        cdef ctextedit.TextEditor* _ptr = new ctextedit.TextEditor()
        cdef TextEditor instance = TextEditor.from_ref(deref(_ptr))
        instance._owner = True
        return instance

    def render(self, str title, float size_x, float size_y, border=False):
        self._ptr.Render(_bytes(title), _cast_args_ImVec2(size_x, size_y), border)

