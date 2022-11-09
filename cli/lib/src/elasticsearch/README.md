### Creating an index in Elasticsearch
First create it in the DEV elasticsearch deployment:
```
monarch_automation -s dev elasticsearch --create-index --index foo_01 --json ~/temp-local/foo_01.json
```

The json file should contain the field mappings of the index being created. Example:
```
{
    "mappings": {
        "dynamic": false,
        "properties": {
            "email": {
                "type": "keyword"
            },
            "name": {
                "type": "text"
            }
        }
    }
}
```

To create it in the PROD deployment use `-s prod`.

Before we had the monarch_automation command, we had to do it by hand. Here is how
to do it by hand: 

> Make sure to create the index with field mappings. There is a file in this 
> directory with a sample of the field mappings used for the `crashes_*` index.

> To create the index login to elastic cloud. Then go to the 
> Elasticsearch > API Console. Then, for example, to send a request that creates 
> the index `crashes_01` submit this request:

> PUT /crashes_01
> (copy and paste the contents of file index_mappings/crashes.json in the body of the request)

> Then submit the request. Your index should be created.

> Make sure to update the code to use the new index, see `crashesIndex` in 
> crash_reports_api.dart and elasticsearch_indexes.dart.

#### Create index pattern so you can search
Then you will need to create an index pattern for your new index. The index pattern is what Kibana uses for searching. As part of creating the index pattern you will have to select the time field. The time field for the crashes mappings should be `crash_entry.timestamp`.


### Adding field mappings
First add the new fields in the DEV elasticsearch deployment:
```
monarch_automation -s dev elasticsearch --add-fields --index foo_01 --json ~/temp-local/add_some_fields.json
```

The json file should contain the new field mappings to add. Example:
```
{
    "properties": {
        "company": {
            "type": "text",
            "fields": {
                "raw": {
                    "type": "keyword"
                }
            }
        }
    }
}
```
The example above adds the field company and stores it as text and keyword, that way it
can be searched and aggregated.

To add it in the PROD deployment use `-s prod`.

Before we had the monarch_automation command, we had to do it by hand. Here is how
to do it by hand: 

> Below is an example that adds `context_info.time_zone.name` and 
> `context_info.time_zone.offset_in_hours`. Make sure you use the right index:

```
PUT /crashes_03/_mapping
{
    "properties": {
        "context_info": {
            "properties": {
                "time_zone": {
                    "properties": {
                        "name": {
                            "type": "keyword"
                        },
                        "offset_in_hours": {
                            "type": "integer"
                        }
                    }
                }
            }
        }   
    }
}
```
> After you submit that you will need to create some document and then refresh the 
> index in kibana.


### Renaming a field mapping
You cannot rename fields in docs that have already been indexed. What you can do is create a new index and re-index the existing documents into the new index using a rename processor.

1. Create a new index. Example:
```
PUT /crashes_03
{
  ...
}
```

2. Create an Ingest pipeline, that contains a Rename Processor. The example below renames several fields. The pipeline needs a name. In the example the name is `rename_monarch_binaries_fields`. `rename.field` is the old field name. `rename.target_field` is the new name of the field mapping. The example also sets a value for a 
```
PUT /_ingest/pipeline/rename_monarch_binaries_fields
{
  "description" : "rename_monarch_binaries_fields",
  "processors": [
      {
        "rename": {
          "field": "context_info.tools_versions.mac_app_version",
          "target_field": "context_info.monarch_binaries.desktop_app_version"
        }
      },
      {
        "rename": {
          "field": "context_info.tools_versions.task_runner_version",
          "target_field": "context_info.monarch_binaries.cli_version"
        }
      },
      {
        "rename": {
          "field": "context_info.tools_versions.tools_version",
          "target_field": "context_info.monarch_binaries.version"
        }
      }
    ]
}
```

3. Then re-index your old index into the new index using the rename processor you just created.
```
POST /_reindex
{
  "source": {
    "index": "crashes_01"
  },
  "dest": {
    "index": "crashes_03",
    "pipeline": "rename_monarch_binaries_fields"
  }
}
```
You may get some errors if some of the original documents don't have the old mappings. Those may be ok.

4. Delete the ingest pipeline you just created unless you want it to continue to run. Example:
```
DELETE /_ingest/pipeline/rename_monarch_binaries_fields
```

5. Create the index pattern for the new index you created in step 1.
6. Update the code to use the new index, see `crashesIndex` in crash_reports_api.dart.


### Renaming fields, ignoring missing fields and setting default value of field
```
PUT /_ingest/pipeline/rename_build_tool_info
{
    "description": "rename fields for platform_build_tool_info",
    "processors": [
        {
            "rename": {
                "field": "context_info.xcode_info.build_version",
                "target_field": "context_info.platform_build_tool_info.build_version",
                "ignore_missing": true
            }
        },
        {
            "rename": {
                "field": "context_info.xcode_info.version",
                "target_field": "context_info.platform_build_tool_info.version",
                "ignore_missing": true
            }
        },
        {
            "set": {
                "field": "context_info.platform_build_tool_info.tool_name",
                "value": "xcodebuild"
            }
        }
    ]
}
```
```
POST /_reindex
{
  "source": {
    "index": "crashes_03"
  },
  "dest": {
    "index": "crashes_07",
    "pipeline": "rename_build_tool_info"
  }
}
```
```
DELETE /_ingest/pipeline/rename_build_tool_info
```

### Getting mapping definition for an index
The index mapping definitions are in json files in the elasticsearch/index_mappings
directory. We try to keep those current. To get the mapping definition of an
index directly from elasticsearch, run the query below:
```
// to get the mapping definition of the `user_selection_01` index

GET /user_selection_01/_mapping
```