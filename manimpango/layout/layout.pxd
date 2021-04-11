from ..renderer.renderer cimport BaseRenderer
from pango cimport *
cdef class Layout:
    cdef PangoLayout* layout
    cdef BaseRenderer renderer
