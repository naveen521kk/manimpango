# This file contains declaration of Layout class
# where it will as a Paragraph of Text, where it
# will possible to use attributes to edits parts
# of the texts. This object will be similar to
# how PangoLayout is but is more Pythonical.
# TODO: Possibly create a Python Wrapper so things
# gets a bit easy.
from ..utils import Alignment
cdef class Layout:
    def __cinit__(self, renderer: BaseRenderer):
        # this is the place where we should initialise
        # things. So, first initialse layout.
        # this will create a ``LayoutRenderer`` and it
        # use that everywhere.
        self.renderer = renderer
        self.layout = renderer.layout
    def __init__(self, renderer: BaseRenderer):
        pass

    @property
    def alignment(self) -> Alignment:
        """Alignment: how partial lines
        are positioned within the horizontal space available.
        """
        cdef PangoAlignment align
        align = pango_layout_get_alignment(self.layout)
        if align == PANGO_ALIGN_CENTER:
            return Alignment.CENTER
        elif align == PANGO_ALIGN_LEFT:
            return Alignment.LEFT
        elif align == PANGO_ALIGN_RIGHT:
            return Alignment.RIGHT

    @alignment.setter
    def alignment(self, alignment: Alignment) -> None:
        pango_layout_set_alignment(self.layout, alignment.value)

    # @property
    # def attributes(self):
    #     pass

    @property
    def auto_dir(self):
        """Whether to calculate the base direction
        for the layout according to its contents.
        
        When this flag is on (the default), then paragraphs
        in ``layout`` that begin with strong right-to-left
        characters (Arabic and Hebrew principally), will have
        right-to-left layout, paragraphs with letters from other
        scripts will have left-to-right layout. Paragraphs with
        only neutral characters get their direction from the 
        surrounding paragraphs.

        When False, the choice between left-to-right and right-to-left
        layout is done according to the base direction of the layout’s
        PangoContext. (See pango_context_set_base_dir()).

        When the auto-computed direction of a paragraph differs
        from the base direction of the context, the interpretation
        of PANGO_ALIGN_LEFT and PANGO_ALIGN_RIGHT are swapped.
        """
        return bool(pango_layout_get_auto_dir(self.layout))

    @auto_dir.setter
    def auto_dir(self, auto_dir: bool):
        pango_layout_set_auto_dir(self.layout, auto_dir)
    
    