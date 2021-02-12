SHELL := /bin/bash

VENV ?= source venv/bin/activate

venv:
	virtualenv -p python3.7 venv

install: venv
	$(VENV) && python setup.py install

uninstall: venv
	$(VENV) && pip uninstall s2-py

wheel: venv
	$(VENV) && python setup.py bdist_wheel

wheel-install: wheel
	$(VENV) && pip install dist/*.whl

sdist: venv
	$(VENV) && python setup.py sdist

sdist-install: sdist
	$(VENV) && pip install dist/*.tar.gz -v

console: venv
	$(VENV) && python

import: venv
	$(VENV) && python -c "import s2_py as s2; print(s2)"

cmake-build: venv
	mkdir -p build
	$(VENV) && cd build && cmake .. && make

upload: sdist
	$(VENV) && pip install twine && twine upload dist/*

clean:
	rm -rf build dist **/s2_py.egg-info venv *.so pywraps2.py *.cxx
