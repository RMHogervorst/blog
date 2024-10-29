---
title: 'Dagster: Integrating Jobs with Assets and Vice Versa.'
author: Roel M. Hogervorst
date: '2024-10-29'
slug: dagster-integrating-jobs-with-assets-and-vice-versa
categories:
  - blog
tags:
  - Dagster
  - data_engineering
  - TIL
subtitle: ''
image: 
difficulty:
  - intermediate
post-type:
  - lessons-learned
summary: Today I learned (TIL) you can actually run jobs based on assets and vice versa.
---

Today I learned (TIL) you can actually run jobs based on assets and vice versa.

# Assets VS Jobs
In dagster you have assets, jobs, ops, sensors and schedules. 
I have been using dagster for a few years, since before the assets were introduced. 
Assets are awesome: I don't care that much about the data engineering processes 
themselves, I care about the results! And that is what assets are focused on.
And because you can let assets depend on each other you can set up processes without 
hacks such as checking if a job is finished or not. 
But some processes do not deliver a product at the end, setting up permissions in a database, 
correcting known mistakes, some variants of triggering webhooks, etc. In those
cases you want to use 'ops' and 'jobs', the traditional way of working.


But what if you have several processes, where some are traditional jobs/ops and some are assets? 
And somehow your job depends on the asset? For example: run a cleaning process after a table is created.
I had the feeling that you had to rewrite the second job into an asset, 
even if that was not semantically correct. But you don' t have to!

# Assets AND jobs
You can materialize an asset, hook up an asset sensor that senses materialization 
and the sensor can then start a job.

Here is some example code to make it a bit more clear:

- `asset_1` for example creates a table
- `asset_1_sensor` waits for a Materialization event and triggers
- `job_a`

```python
# pseudo code, misses all the important things

@asset
def asset_1():
	"""An asset that you care about."""
    #something
    return

@asset_sensor(asset_key=AssetKey("asset_1"), job=job_a)
def asset_1_sensor():
	yield RunRequest()


def job_a():
	"""A job, with no data product as end product."""
	pass
	
```

The other way around works too.
You can have a job that materializes an asset. and Assets that depend on that further.

- `job_b` materializes an asset
- `asset_2`
- `asset_3` depends on asset_2

```python
# pseudo code, misses all the important things
@job
def job_b():
	"""A job that materializes an asset."""
	# some work
	
	context.log_event(
        AssetMaterialization(asset_key="asset_2")
        )

@asset(deps=["asset_2"])
def asset_3():
	#some work
	pass

```

This is super useful, but there are some caveats:

- when you make everything assets, you can instruct dagster to refresh all assets in the chain, but it does not 'know' how to start a traditional job. So this sort of breaks the chain.
- An asset created by a job that has a materialization event, is seen as an 'external asset', and so dagster 'believes' it is not under its control. You can go downstream from an external asset, but you cannot couple 'real' assets as dependencies.

So, if you have many jobs that all need to work after each other, 
you better rewrite it into assets, 
but if you have a few incidental jobs with not a lot of downstream 
dependencies you can chain them up to assets.


## Notes

- I wrote about dagster before: see [tag: "dagster"](https://blog.rmhogervorst.nl/tags/dagster/)
- [dagster docs: asset sensors](https://release-1-8-9.dagster.dagster-docs.io/concepts/partitions-schedules-sensors/asset-sensors "A link to a stable version of dagster, latest might be a few versions further now.")