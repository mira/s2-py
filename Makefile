SHELL := /bin/bash

VENV ?= source venv/bin/activate

venv:
	virtualenv -p python3 venv

install:
	$(VENV) && python setup.py install

uninstall:
	$(VENV) && pip uninstall s2-py

wheel:
	$(VENV) && python setup.py bdist_wheel

wheel-install: wheel
	$(VENV) && pip install dist/*.whl

sdist:
	$(VENV) && python setup.py sdist

sdist-install: sdist
	$(VENV) && pip install dist/*.tar.gz -v

console:
	$(VENV) && python

import:
	$(VENV) && python -c "import s2_py as s2; print(s2)"

clean:
	rm -rf build dist **/s2_py.egg-info venv *.so pywraps2.py *.cxx