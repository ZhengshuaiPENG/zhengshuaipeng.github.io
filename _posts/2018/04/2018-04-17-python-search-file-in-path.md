---
layout: post
title:  "[Python] Search file in a given path"
date:   2018-04-17
desc: "Use python to search target file in a given path"
keywords: "Python, io, search file"
categories: [python]
---

# I. Search file in a give path by using python

Sometimes we need to process files in server(linux env). Faced on many files, sometimes you may want to search just one file in a given path recursively. Below is a implementation script snippets by using Python.

```python
def search(rdf_raw_data_path, target_file):
    for root, dirs, files in os.walk(rdf_raw_data_path):
        complete_path = glob.glob(os.path.join(root, target_file))
        if complete_path:
            return complete_path[0]
```

Here ```target_file``` accept wildcard character