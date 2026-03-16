SHELL := /bin/bash

DEPS_DIR := $(CURDIR)/deps
CMAKE_ARGS := -DCMAKE_PREFIX_PATH=$(DEPS_DIR)/abseil-install -DSWIG_EXECUTABLE=$(DEPS_DIR)/swig-install/bin/swig -DOPENSSL_ROOT_DIR=/opt/homebrew/opt/openssl@3 -DOPENSSL_USE_STATIC_LIBS=TRUE
export CMAKE_ARGS

.PHONY: install clean deps deps-abseil deps-swig

deps: deps-abseil deps-swig

deps-abseil: $(DEPS_DIR)/abseil-install/lib/cmake/absl/abslConfig.cmake

$(DEPS_DIR)/abseil-install/lib/cmake/absl/abslConfig.cmake:
	mkdir -p $(DEPS_DIR)
	curl -L https://github.com/abseil/abseil-cpp/archive/refs/tags/20240722.0.tar.gz | tar xz -C $(DEPS_DIR)
	cd $(DEPS_DIR)/abseil-cpp-20240722.0 && mkdir -p build && cd build && \
		cmake .. -DCMAKE_CXX_STANDARD=17 -DCMAKE_INSTALL_PREFIX=$(DEPS_DIR)/abseil-install -DABSL_BUILD_TESTING=OFF && \
		make -j$$(sysctl -n hw.ncpu) && make install

deps-swig: $(DEPS_DIR)/swig-install/bin/swig

$(DEPS_DIR)/swig-install/bin/swig:
	mkdir -p $(DEPS_DIR)
	curl -L https://github.com/swig/swig/archive/refs/tags/v4.2.1.tar.gz | tar xz -C $(DEPS_DIR)
	cd $(DEPS_DIR)/swig-4.2.1 && ./autogen.sh && \
		PATH="/opt/homebrew/opt/bison/bin:$$PATH" ./configure --prefix=$(DEPS_DIR)/swig-install --without-alllang --with-python && \
		PATH="/opt/homebrew/opt/bison/bin:$$PATH" make -j$$(sysctl -n hw.ncpu) && make install

install: deps
	uv sync

uninstall:
	uv pip uninstall s2-py

console: install
	uv run python

import: install
	uv run python -c "import s2_py as s2; print(s2)"

wheel: deps
	uv build --wheel

clean:
	uv cache clean
	cd lib/s2_py && rm -rf s2geometry.py _s2geometry* *.so *.cxx *.dylib
	rm -rf build dist **/s2_py.egg-info .venv

clean-deps:
	rm -rf $(DEPS_DIR)
