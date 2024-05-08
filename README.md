# taimore's python template repository

## status
[![Build & Test](https://github.com/tk3413/tk-python/actions/workflows/ci.yml/badge.svg)](https://github.com/tk3413/tk-python/actions/workflows/ci.yml)
[![Code Quality](https://github.com/tk3413/tk-python/actions/workflows/code_quality.yml/badge.svg?branch=main)](https://github.com/tk3413/tk-python/actions/workflows/code_quality.yml)

## contents

- depedency management
- server code that responds 'howdy'
- example test case that passes
- dockerfile
- makefile
- readme
- terraform to deploy it onto an ecs cluster
- gherkin-style acceptance test suite
- ci
- code quality scans

## todo

- cd
- monitoring
- alerting
- cost analysis

## manual steps

- create dockerhub repository
- update main.tf

## setup and local execution

```
python3 -m virtualenv venv
source venv/bin/activate
pip3 install -r requirements.txt
```

for testing, once you've done the steps above:
```
pytest
```
