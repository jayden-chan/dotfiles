import sys
import sqlparse

contents = sys.stdin.read()
for identifier in range(10):
    contents = contents.replace(f"?{identifier}", f"__id_{identifier}")

contents = contents.replace("r#\"", "")
contents = contents.replace("\"#", "")

snippets = contents.split("---")
results = []

for snippet in snippets:
    trimmed_snippet = snippet.strip()
    if len(trimmed_snippet) != 0:
        result = sqlparse.format(trimmed_snippet
                                 , indent_columns=True
                                 , keyword_case='upper'
                                 , identifier_case='lower'
                                 , reindent=True
                                 , output_format='sql'
                                 , indent_after_first=True
                                 , wrap_after=60
                                 , comma_first=True
                                 )

        for identifier in range(10):
            result = result.replace(f"__id_{identifier}", f"?{identifier}")

        print(result.strip())
        print("---")
