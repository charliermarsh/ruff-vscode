default: fmt check

lock:
  pip-compile --generate-hashes --resolver=backtracking -o ./requirements.txt ./pyproject.toml
  pip-compile --generate-hashes --resolver=backtracking --upgrade --extra dev -o ./requirements-dev.txt ./pyproject.toml
  npm install --package-lock-only

setup:
  pip install -t ./bundled/libs --no-cache-dir --implementation py --no-deps --upgrade -r ./requirements.txt

install:
  pip install --no-deps -r ./requirements.txt
  pip install --no-deps -r ./requirements-dev.txt
  npm ci

test: setup
  python -m unittest

check:
  ruff ./bundled/tool ./build ./tests
  black --check ./bundled/tool ./build ./tests
  mypy ./bundled/tool ./build ./tests
  npm run lint
  npm run typecheck

fmt:
  ruff --fix ./bundled/tool ./build ./tests
  black --check ./bundled/tool ./build ./tests
  npm run fmt

build-package: setup
  npm ci
  npm run vsce-package
