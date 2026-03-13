SHELL := /bin/bash

.PHONY: install clean

install:
	uv sync

uninstall:
	uv pip uninstall s2-py

console: install
	uv run python

import: install
	uv run python -c "import s2_py as s2; print(s2)"

wheel:
	uv build --wheel

clean:
	uv cache clean
	cd lib/s2_py && rm -rf pywraps2.py *.so *.cxx *.dylib
	rm -rf build dist **/s2_py.egg-info .venv
