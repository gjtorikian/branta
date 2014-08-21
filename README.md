Branta
============

Branta is a Rails app that listens for [`PageBuildEvent`][PageBuildEvent]s sent by GitHub. On a successful GitHub Pages build, the app will index your site for search. You can then make `GET` requests (with AJAX) on your Pages site and implement a full site search.

[![Build Status](https://travis-ci.org/gjtorikian/branta.svg?branch=master)](https://travis-ci.org/gjtorikian/branta)

## How does it index?

Branta prefers that you have a sitemap.xml file defined at your root, as it makes indexing the content of your site much easier and more reliable. Otherwise, it uses [anemone](https://github.com/chriskite/anemone) to walk over all your pages.

## What does it index?

The following parts of each page are indexed:

* The title
* The body
* The path
* The GitHub pages repository the site belongs to
* When the page was last updated

[Pismo](https://github.com/peterc/pismo) is used to collect most of this information.

## Examples and parameters

Basically, you're going to want to make your queries against `/search`:

```
http://your-branta.com/search?q=query
```

Searches are made against the title and body of each page.

Here are the parameters available to you:

|Query parameter | Description | Sample
|----------------|-------------|----------
`page` | The page number of the results you want. | `http://your-branta.com/search?q=query&page=2`
|`sort` | Which parameter you want to sort on. The default is relevancy score. You can sort on any of the indexed information. | `http://your-branta.com/search?q=query&sort=updated_at`
|`order` | The ordering of your sort. The default is `desc`. | `http://your-branta.com/search?q=query&sort=updated_at&order=asc`
|`repo` | The repository you want to search in. Use a comma-separated list to pass in more than one. | `http://your-branta.com/search?q=query&repo=gjtorikian/test1`<br />`http://your-branta.com/search?q=query&repo=gjtorikian/test1,gjtorikian/test2`
|`path` | The path you want to search in. Use a comma-separated list to pass in more than one. | `http://your-branta.com/search?q=query&path=articles`<br />`http://your-branta.com/search?q=query&path=articles/new,articles/fresh`

## Highlighting

Matched terms in the body are returned in a `<span class="search-term">` tag.

## Dependencies

This app depends on the following systems:

* Redis (for Resque)
* Elasticsearch `~> 1.0.0`
* PostgreSQL

## Starting the server locally

```
script/bootstrap
rake search:force_create_index
script/server
```

## Environment variables

If you're running Branta yourself, you should set the following environment variables:

|Envrionment variable | Description
|---------------------|------------
`GITHUB_BRANTA_CLIENT_ID` | The client ID of your Branta OAuth app instance.
`GITHUB_BRANTA_CLIENT_SECRET` | The client secret of your Branta OAuth app instance.

### TODO:

- Some kind of UI for the landing page

[PageBuildEvent]: https://developer.github.com/v3/activity/events/types/#pagebuildevent
