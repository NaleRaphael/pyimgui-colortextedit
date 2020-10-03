# -*- coding: utf-8 -*-
# distutils: language = c++
# distutils: include_dirs = imgui-cpp imgui-colortextedit
from libcpp cimport bool

# See also: https://cython.readthedocs.io/en/latest/src/userguide/wrapping_CPlusPlus.html#standard-library
from libcpp.string cimport string
from libcpp.vector cimport vector
from libcpp.utility cimport pair


cdef extern from "imgui.h":
    ctypedef struct ImDrawChannel
    ctypedef struct ImDrawCmd
    ctypedef struct ImDrawData
    ctypedef struct ImDrawList
    ctypedef struct ImDrawListSharedData
    ctypedef struct ImDrawVert
    ctypedef struct ImFont
    ctypedef struct ImFontAtlas
    ctypedef struct ImFontConfig
    ctypedef struct ImColor
    ctypedef struct ImGuiIO
    ctypedef struct ImGuiOnceUponAFrame
    ctypedef struct ImGuiStorage
    ctypedef struct ImGuiTextFilter
    ctypedef struct ImGuiTextBuffer
    ctypedef struct ImGuiInputTextCallbackData
    ctypedef struct ImGuiSizeCallbackData
    ctypedef struct ImGuiListClipper
    ctypedef struct ImGuiPayload
    ctypedef struct ImGuiContext

    ctypedef void* ImTextureID
    ctypedef unsigned int ImU32
    ctypedef unsigned int ImGuiID
    ctypedef unsigned short ImWchar
    ctypedef int ImGuiCol
    ctypedef int ImGuiDataType
    ctypedef int ImGuiDir
    ctypedef int ImGuiCond
    ctypedef int ImGuiKey
    ctypedef int ImGuiNavInput
    ctypedef int ImGuiMouseCursor
    ctypedef int ImGuiStyleVar
    ctypedef int ImDrawCornerFlags
    ctypedef int ImDrawListFlags
    ctypedef int ImFontAtlasFlags
    ctypedef int ImGuiBackendFlags
    ctypedef int ImGuiColorEditFlags
    ctypedef int ImGuiColumnsFlags
    ctypedef int ImGuiConfigFlags
    ctypedef int ImGuiComboFlags
    ctypedef int ImGuiDragDropFlags
    ctypedef int ImGuiFocusedFlags
    ctypedef int ImGuiHoveredFlags
    ctypedef int ImGuiInputTextFlags
    ctypedef int ImGuiSelectableFlags
    ctypedef int ImGuiTreeNodeFlags
    ctypedef int ImGuiWindowFlags
    ctypedef int (*ImGuiInputTextCallback)(ImGuiInputTextCallbackData *data);
    ctypedef void (*ImGuiSizeCallback)(ImGuiSizeCallbackData* data);

    ctypedef struct ImVec2:
        float x
        float y

    ctypedef struct ImVec4:
        float x
        float y
        float z
        float w


    ctypedef struct ImGuiIO:
        ImGuiConfigFlags   ConfigFlags
        ImGuiBackendFlags  BackendFlags
        ImVec2        DisplaySiz
        float         DeltaTime
        float         IniSavingRate
        const char*   IniFilename
        const char*   LogFilename
        float         MouseDoubleClickTime
        float         MouseDoubleClickMaxDist
        float         MouseDragThreshold
        int*          KeyMap
        float         KeyRepeatDelay
        float         KeyRepeatRate
        void*         UserData

        ImFontAtlas*  Fonts
        float         FontGlobalScale
        bool          FontAllowUserScaling
        ImVec2        DisplayFramebufferScale
        ImVec2        DisplayVisibleMin
        ImVec2        DisplayVisibleMax
        bool          ConfigMacOSXBehaviors
        bool          ConfigInputTextCursorBlink
        bool          ConfigResizeWindowsFromEdges

        const char* (*GetClipboardTextFn)(void* user_data) except +
        void        (*SetClipboardTextFn)(void* user_data, const char* text) except +
        void*       ClipboardUserData

        void*       (*MemAllocFn)(size_t sz) except +
        void        (*MemFreeFn)(void* ptr) except +
        void        (*ImeSetInputScreenPosFn)(int x, int y) except +
        void*       ImeWindowHandle

        ImVec2      MousePos
        bool        MouseDown[5]
        float       MouseWheel
        float       MouseWheelH
        bool        MouseDrawCursor
        bool        KeyCtrl
        bool        KeyShift
        bool        KeyAlt
        bool        KeySuper
        bool        KeysDown[512]
        ImWchar     InputCharacters[16+1]

        void        AddInputCharacter(ImWchar c) except +
        void        AddInputCharactersUTF8(const char* utf8_chars) except +
        void        ClearInputCharacters() except +

        bool        WantCaptureMouse
        bool        WantCaptureKeyboard
        bool        WantTextInput
        bool        WantSetMousePos
        bool        WantSaveIniSettings
        bool        NavActive
        bool        NavVisible
        float       Framerate
        int         MetricsRenderVertices
        int         MetricsRenderIndices
        int         MetricsActiveWindows
        ImVec2      MouseDelta


cdef extern from "imgui.h" namespace "ImGui":
    ImGuiContext* CreateContext(
            ImFontAtlas* shared_font_atlas
    ) except +
    void DestroyContext(ImGuiContext* ctx) except +
    ImGuiContext* GetCurrentContext() except +
    void SetCurrentContext(ImGuiContext* ctx) except +
    bool DebugCheckVersionAndDataLayout(const char* version_str, size_t sz_io, size_t sz_style, size_t sz_vec2, size_t sz_vec4, size_t sz_drawvert) except +


cdef extern from "TextEditor.h":
    cdef cppclass TextEditor:
        void SetLanguageDefinition(const LanguageDefinition& aLanguageDef) except +
        const LanguageDefinition& GetLanguageDefinition() except +

        const Palette& GetPalette() except +
        void SetPalette(const Palette& aValue) except +

        void Render(const char* aTitle, const ImVec2& aSize, bool aBorder) except +


cdef extern from "TextEditor.h" namespace "TextEditor":
    cdef cppclass PaletteIndex:
        pass

    cdef cppclass SelectionMode:
        pass

    ctypedef pair[string, PaletteIndex] TokenRegexString
    ctypedef vector[TokenRegexString] TokenRegexStrings
    ctypedef struct Palette

    ctypedef struct LanguageDefinition:
        TokenRegexString TokenRegexString
        TokenRegexStrings TokenRegexStrings


cdef extern from "TextEditor.h" namespace "PaletteIndex":
    cdef PaletteIndex Default
    cdef PaletteIndex KeyWord
    cdef PaletteIndex Number
    cdef PaletteIndex String
    cdef PaletteIndex CharLiteral
    cdef PaletteIndex Punctuation
    cdef PaletteIndex Preprocessor
    cdef PaletteIndex Identifier
    cdef PaletteIndex KnownIdentifier
    cdef PaletteIndex PreprocIdentifier
    cdef PaletteIndex Comment
    cdef PaletteIndex MultiLineComment
    cdef PaletteIndex Background
    cdef PaletteIndex Cursor
    cdef PaletteIndex Selection
    cdef PaletteIndex ErrorMarker
    cdef PaletteIndex Breakpoint
    cdef PaletteIndex LineNumber
    cdef PaletteIndex CurrentLineFill
    cdef PaletteIndex CurrentLineFillInactive
    cdef PaletteIndex CurrentLineEdge
    cdef PaletteIndex Max


cdef extern from "TextEditor.h" namespace "SelectionMode":
    cdef SelectionMode Normal
    cdef SelectionMode Word
    cdef SelectionMode Line
