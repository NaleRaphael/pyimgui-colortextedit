import os, sys
from pathlib import Path
from setuptools import setup, Extension, find_packages
from Cython.Build import cythonize


def get_source_files(path_str):
    sources = [str(f) for f in Path(path_str).rglob('*.pyx')]
    return sources


def setup_package():
    excluded = []
    desc = "A Cython wrapper for `BalazsJako/ColorTextEditorDemo`."

    EXTENSIONS = [
        Extension(
            'colortextedit.texteditor', get_source_files('colortextedit'),
            include_dirs=['imgui-cpp', 'imgui-colortextedit-cpp', 'colortextedit'],
        ),
    ]

    metadata = dict(
        name='imgui_colortextedit',
        version='0.1.0',
        packages=find_packages('colortextedit', exclude=excluded),
        author='naleraphael',
        author_email='gmccntwxy@gmail.com',
        description=desc,
        url='https://github.com/naleraphael/imgui-colortextedit',
        ext_modules=cythonize(EXTENSIONS),
        include_package_data=True,
        classifiers=[
            'License :: OSI Approved :: MIT License',
            'Programming Language :: Python :: 3.6',
            'Programming Language :: Python :: Implementation :: CPython',
            'Programming Language :: Cython',
        ],
        python_requires='>=3.6',
        license='MIT',
    )

    setup(**metadata)


if __name__ == '__main__':
    setup_package()
