
cdef class FontDescription:

    def __cinit__(self):
        self.font_description = pango_font_description_new()

    def __init__(self):
        """A :class:`FontDescription` describes a font.

        :class:`FontDescription` is used for specifying the
        characteristics of a font to load.
        """
        pass

    @property
    def family(self):
        family = pango_font_description_get_family(self.font_description)
        if family == NULL:
            return None
        else:
            return family.decode('utf-8')

    @family.setter
    def family(self, family: str):
        pango_font_description_set_family(
            self.font_description,
            family.encode('utf-8'),
        )

    #@property
    #def gravity(self):
    #    family = pango_font_description_get_family(self.font_description)
    #    if family == NULL:
    #        return None
    #    else:
    #        return family.decode('utf-8')

    #@gravity.setter
    #def gravity(self, gravity: str):
    #    pango_font_description_set_family(
    #        self.font_description,
    #        family.encode('utf-8'),
    #    )

    def __eq__(self, other: FontDescription) -> bool:
        if isinstance(other, FontDescription):
            return bool(pango_font_description_equal(self.font_description, other.font_description))
        return NotImplemented

    def __copy__(self) -> FontDescription:
        font_ft = FontDescription()
        pango_font_description_free(font_ft.font_description)
        font_ft.font_description = pango_font_description_copy(self.font_description)
        return font_ft

    def __deepcopy__(self, memo) -> FontDescription:
        return self.__copy__()

    def __repr__(self) -> str:
        return "<FontDescription>"

    def __dealloc__(self):
        pango_font_description_free(self.font_description)
