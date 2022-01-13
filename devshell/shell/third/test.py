import isort

sorted_code = isort.code("import b\nimport a\n")
print(sorted_code)
