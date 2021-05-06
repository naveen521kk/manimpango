# -*- coding: utf-8 -*-

import attr
import typing
from ..utils import Style, Varient, Weight


@attr.s
class FontProperties:
    family: typing.Optional[str] = attr.ib(
        validator=attr.validators.optional(attr.validators.instance_of(str)),
        default=None,
    )
    size: typing.Optional[float] = attr.ib(
        validator=attr.validators.optional(attr.validators.instance_of(float)),
        default=None,
    )
    style: typing.Optional[Style] = attr.ib(
        validator=attr.validators.optional(attr.validators.instance_of(Style)),
        default=None,
    )
    variant: typing.Optional[Varient] = attr.ib(
        validator=attr.validators.optional(attr.validators.instance_of(Varient)),
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
    def check_markup(self, attribute, value):
        if value == 0:
            raise ValueError("Size shouldn't be Zero.")
    # def from_string(self):
    #     pass
    # def to_string(self):
    #     pass

    # TODO: Implement register font here