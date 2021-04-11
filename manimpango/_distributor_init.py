"""
Helper to preload windows dlls to prevent dll not found errors.
Once a DLL is preloaded, its namespace is made available to any
subsequent DLL.
"""
import glob
import os

if os.name == "nt":
    try:
        from ctypes import WinDLL

        basedir = os.path.dirname(__file__)
    except:
        pass
    else:
        for filename in glob.glob(os.path.join(basedir, "*.dll")):
            WinDLL(os.path.abspath(filename))
    if hasattr(os,'add_dll_directory'):
        os.add_dll_directory(basedir)