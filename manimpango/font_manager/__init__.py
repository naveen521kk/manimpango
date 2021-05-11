# -*- coding: utf-8 -*-

import errno
import typing
from pathlib import Path

import attr

from ..utils import Style, Variant, Weight, list_fonts
from ._register_font import (fc_register_font, fc_unregister_font,
                             register_font, unregister_font)

__all__ = ["FontProperties", "RegisterFont"]


@attr.s
class FontProperties:
    family: typing.Optional[str] = attr.ib(
        validator=attr.validators.optional(attr.validators.instance_of(str)),
        default=None,
    )
    size: typing.Optional[float] = attr.ib(
        validator=attr.validators.optional(attr.validators.instance_of((float, int))),
        default=None,
    )
    style: typing.Optional[Style] = attr.ib(
        validator=attr.validators.optional(attr.validators.instance_of(Style)),
        default=None,
    )
    variant: typing.Optional[Variant] = attr.ib(
        validator=attr.validators.optional(attr.validators.instance_of(Variant)),
        default=None,
    )
    weight: typing.Optional[Weight] = attr.ib(
        validator=attr.validators.optional(attr.validators.instance_of(Weight)),
        default=None,
    )
    # stretch
    # gravity
    # variations
    @size.validator
    def check_size(self, attribute, value):
        if value == 0:
            raise ValueError("Size shouldn't be Zero.")

    # def from_string(self):
    #     pass
    # def to_string(self):
    #     pass


@attr.s(frozen=True)
class RegisterFont(object):
    font_file: typing.Union[str, Path] = attr.ib(
        validator=[attr.validators.instance_of((str, Path))],
    )
    use_fontconfig: bool = attr.ib(
        validator=[attr.validators.instance_of(bool)], default=False, repr=False
    )
    calculate_family: bool = attr.ib(
        validator=[attr.validators.instance_of(bool)], default=True, repr=False
    )
    family: typing.Optional[str] = attr.ib(default=None)

    @font_file.validator
    def check_font_file(self, attribute, value):
        if not Path(value).exists():
            raise FileNotFoundError(
                errno.ENOENT,
                f"{value} doesn't exists.",
            )
        if not Path(value).is_file():
            raise FileNotFoundError(
                errno.ENOENT,
                f"{value} isn't a valid file",
            )

    def __attrs_post_init__(self):
        if self.calculate_family:
            intial = list_fonts(self.use_fontconfig)
        font_file = self.font_file
        if self.use_fontconfig:
            status = fc_register_font(str(font_file))
            if not status:
                raise RuntimeError(
                    f"Can't register font file {font_file}. "
                    "Maybe it's an invalid file ?"
                )
        else:
            status = register_font(str(font_file))
            if not status:
                raise RuntimeError(
                    f"Can't register font file {font_file}. "
                    "Maybe it's an invalid file ?"
                )
        if self.calculate_family:
            final = list_fonts(self.use_fontconfig)
            family = list(set(final) - set(intial)) or None
            super().__setattr__("family", family)
        else:
            super().__setattr__("family", None)

    def unregister(self):
        if self.use_fontconfig:
            fc_unregister_font(str(self.font_file))
        else:
            unregister_font(str(self.font_file))
