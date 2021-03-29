# This file contains declaration of Layout class
# where it will as a Paragraph of Text, where it
# will possible to use attributes to edits parts 
# of the texts. This object will be similar to
# how PangoLayout is but is more Pythonical.
# TODO: Possibly create a Python Wrapper so things
# gets a bit easy.

cdef class Layout:
    def __cinit__(self, renderer: LayoutRenderer):
        # this is the place where we should initialise
        # things. So, first initialse layout.
        # this will create a ``LayoutRenderer`` and it
        # use that everywhere.
        self._renderer = LayoutRenderer
    def __init__(self, renderer: LayoutRenderer):
        pass
