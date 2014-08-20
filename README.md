Branta
============

Branta is a Rails app that listens for [`PageBuildEvent`][PageBuildEvent]s sent by GitHub. On a successful GitHub Pages build, the app will index your site for search. You can then make `GET` requests (with AJAX) on your Pages site and implement a full site search.

### Dependencies

This app depends on the following systems:

* Redis (for Resque)
* Elasticsearch `~> 1.0.0`
* PostgreSQL

### Starting the server locally

```
script/bootstrap
rake search:force_create_index
script/server
```

### Environment variables

If you're running Branta yourself, you should set the following environment variables:

|Envrionment variable | Description
|---------------------|------------
`GITHUB_BRANTA_CLIENT_ID` | The client ID of your Branta OAuth app instance.
`GITHUB_BRANTA_CLIENT_SECRET` | The client secret of your Branta OAuth app instance.
`BRANTA_PER_PAGE_COUNT` | The number of items per page to return (default: 25).

### TODO:

- Some kind of UI for the landing page

[PageBuildEvent]: https://developer.github.com/v3/activity/events/types/#pagebuildevent
