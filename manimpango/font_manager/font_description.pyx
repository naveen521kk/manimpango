
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
        """str: The family name field of a font description.

        It is also possible to use a comma separated list of family names for this field.

        Parameters
        ----------
        family : :class:`str`
            A string representing the family name.

        Returns
        -------
        :class:`str`, None
            The family name field for the font description,
            or None if not previously set.
        """
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

    @property
    def size(self) -> float:
        """int: Size field of the Font Description.
        This is in ``POINTS`` which means it doesn't depend on the
        screen DPI.  The conversion factor between points and device
        units depends on system configuration and the output device.
        For screen display, a logical DPI of 96 is common, in which
        case a 10 point font corresponds to a 10 * (96 / 72) = 13.3
        pixel font.

        Check :attr:`size_is_absolute` to check whether it is
        absolute or not.

        Parameters
        ----------
        size : :class:`float`
            Size field of a font description.

        Returns
        -------
        :class:`float`
            The size field for the font
            description in points or device units.
        """
        return pango_units_to_double(pango_font_description_get_size(self.font_description))

    @size.setter
    def size(self, size: float):
        pango_font_description_set_size(
            self.font_description,
            pango_units_from_double(size),
        )

    @property
    def size_is_absolute(self) -> bool:
        """Determines whether the size of the font
        is in points (not absolute) or device units (absolute).

        See :attr:`size`

        Returns
        -------
        :class:`bool`

        """
        return bool(pango_font_description_get_size_is_absolute(self.font_description))

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

    # TODO: implement other properties

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
        return f"<FontDescription family={self.family}>"

    def __dealloc__(self):
        pango_font_description_free(self.font_description)
