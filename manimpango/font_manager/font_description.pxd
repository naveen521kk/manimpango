from pango cimport *

cdef class FontDescription:
    cdef PangoFontDescription* font_description
