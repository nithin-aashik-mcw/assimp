"""
Build hook for bundling a prebuilt assimp shared library into the wheel.

Set PYASSIMP_BUNDLE_LIBRARY to the path of the library (for example
build/bin/Release/assimp-vc143-mt.dll) before building. The library is copied
into the pyassimp package and the wheel is tagged for the current platform
(py3-none-<platform>). The bindings use ctypes only, so the wheel works with
any Python 3 on that platform.

Without PYASSIMP_BUNDLE_LIBRARY a pure-Python wheel is built, as before.
"""

import os
import shutil

from setuptools import Distribution, setup
from setuptools.command.bdist_wheel import bdist_wheel as _bdist_wheel
from setuptools.command.build_py import build_py as _build_py

BUNDLE_LIBRARY = os.environ.get("PYASSIMP_BUNDLE_LIBRARY")

if BUNDLE_LIBRARY and not os.path.isfile(BUNDLE_LIBRARY):
    raise FileNotFoundError(
        f"PYASSIMP_BUNDLE_LIBRARY does not point to a file: {BUNDLE_LIBRARY}")


class build_py(_build_py):
    def run(self):
        super().run()
        if BUNDLE_LIBRARY:
            target = os.path.join(self.build_lib, "pyassimp")
            self.mkpath(target)
            shutil.copy2(BUNDLE_LIBRARY, target)


class BinaryDistribution(Distribution):
    # Makes the wheel platform specific and installs it into platlib.
    def has_ext_modules(self):
        return bool(BUNDLE_LIBRARY)


class bdist_wheel(_bdist_wheel):
    def get_tag(self):
        python, abi, plat = super().get_tag()
        if BUNDLE_LIBRARY:
            return "py3", "none", plat
        return python, abi, plat


setup(
    distclass=BinaryDistribution,
    cmdclass={"build_py": build_py, "bdist_wheel": bdist_wheel},
)
