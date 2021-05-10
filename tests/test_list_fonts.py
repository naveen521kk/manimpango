# -*- coding: utf-8 -*-
import sys

import pytest

import manimpango
from manimpango.font_manager._register_font import register_font, unregister_font
from .test_fonts import font_lists


def test_whether_list():
    a = manimpango.list_fonts()
    assert type(a) is list
    assert len(a) > 0


@pytest.mark.skipif(
    sys.platform.startswith("linux") or sys.platform.startswith("darwin"),
    reason="names don't match for some reason.",
)
@pytest.mark.parametrize("font_file", font_lists)
def test_resgister_font_with_list(font_file):
    register_font(str(font_file))
    a = manimpango.list_fonts()
    assert font_lists[font_file] in a
    unregister_font(str(font_file))
