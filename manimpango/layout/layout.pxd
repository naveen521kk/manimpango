cdef class LayoutRenderer:
    cdef PangoLayout* layout
    cdef LayoutRenderer _renderer
    cpdef bint render(self)

cdef class SVGRenderer(BaseRenderer):
