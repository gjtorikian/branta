Branta
============

Branta is a Rails app that listens for [`PageBuildEvent`][PageBuildEvent]s sent by GitHub. On a successful GitHub Pages build, the app will index your site for search. You can then make `GET` requests (with AJAX) on your Pages site and implement a full site search.

[![Build Status](https://travis-ci.org/gjtorikian/branta.svg?branch=master)](https://travis-ci.org/gjtorikian/branta)

## How does it index?

When your page builds successfully, Branta walks over your site and indexes all the content. Branta prefers that you have a *sitemap.xml* file defined at your root, as it makes indexing the content of your site much easier and more reliable (via [sitemap-parser](https://github.com/benbalter/sitemap-parser). Otherwise, it uses [Anemone](https://github.com/chriskite/anemone) to walk over all your pages.

## What does it index?

The following parts of each page are indexed:

* The title
* The body
* The path
* The GitHub pages repository the site belongs to
* When the page was last updated

[Pismo](https://github.com/peterc/pismo) is used to collect most of this information. You can see exactly how this indexed is fetched [in the `IndexJob` ](https://github.com/gjtorikian/branta/blob/master/lib/branta/jobs/index.rb#L114-L123). Also, you can see how the ElasticSearch model is set up in [`Page`](https://github.com/gjtorikian/branta/blob/master/app/models/page.rb#L8-L17).

## Why is this so goddamn great?

Every attempt at "search" for GitHub Pages does it inefficiently: either you have to generate a JSON blob of all your contents, or your search merely filters the text that's visible on the site.

Branta actually indexes your content. It supports stemming and various filters. It works for Jekyll and non-Jekyll static sites, and it requires no plugins on your part to get it to work.

## Hooking up with JavaScript

You're going to want to make your AJAX queries against the `/search` endpoint of Branta:

```
http://your-branta.com/search?q=query
```

Here's an example query with AJAX using jQuery:

```javascript
$.ajax({
  url: "https://branta.io/search?q=commit",
  type: "GET",
  crossDomain: true,
  dataType: "json"
}).done(function(data) {
  var results = data != null ? data.results : null;
  if (results != null && results.length > 0) {
    // iterate over results
  }
});
```

### Payload

Here's an example of the response payload:

``` json
{
  "total":110,
  "results":[
    {
       "result":"\n    You can easily see what branch a &lt;span class=\"search-term\"&gt;commit&lt;/span&gt; is in by looking at the labels beneath the &lt;span class=\"search-term\"&gt;commit&lt;/span&gt; on the &lt;span class=\"search-term\"&gt;commit&lt;/span&gt; page.\n\nIf your &lt;span class=\"search-term\"&gt;commit&lt;/span&gt; is not on the default branch",
       "title":"Commit branch and tag labels",
       "path":"articles/commit-branch-and-tag-labels/index.html",
       "last_updated":"03/06/1984"
    },
    {
       "result":"\n    The git rebase command allows you to easily change a series of &lt;span class=\"search-term\"&gt;commits&lt;/span&gt;, modifying the history of your repository. You can reorder, edit, or squash &lt;span class=\"search-term\"&gt;commits&lt;/span&gt;",
       "title":"About Git rebase",
       "path":"articles/about-git-rebase/index.html",
       "last_updated":"03/06/1984"
    }
  ]
}
```

|JSON key | Description
|----------------|----------
|`total` | Total response from the query. You'll need to paginate to get further results.
|`result` | The chunk of text that matches the query, with the highlighted terms.
|`title` | The title of the page.
|`path` | The path of the page.
|`last_updated` | The time the page was last updated.

Matched terms in the `result` are wrapped in a `<span class="search-term">` tag.

### Search parameters

Here are the parameters available to you:

|Query parameter | Description | Sample
|----------------|-------------|----------
|`q` | **Required**. The search term. | `http://your-branta.com/search?q=query`
|`repo` | **Required**. The repository you want to search in. Use a comma-separated list to pass in more than one. | `http://your-branta.com/search?q=query&repo=gjtorikian/test1`<br />`http://your-branta.com/search?q=query&repo=gjtorikian/test1,gjtorikian/test2`
|`page` | The page number of the results you want. | `http://your-branta.com/search?q=query&page=2`
|`sort` | Which parameter you want to sort on. The default is relevancy score. You can sort on any of the indexed information. | `http://your-branta.com/search?q=query&sort=updated_at`
|`order` | The ordering of your sort. The default is `desc`. | `http://your-branta.com/search?q=query&sort=updated_at&order=asc`
|`path` | The path you want to search in. Use a comma-separated list to pass in more than one. | `http://your-branta.com/search?q=query&path=articles`<br />`http://your-branta.com/search?q=query&path=articles/new,articles/fresh`

## Dependencies

This app depends on the following systems to be running:

* Redis (for Resque)
* Elasticsearch `~> 1.0.0`
* PostgreSQL

## Setting up the server

To run Branta locally, enter the following commands:
```
script/bootstrap
rake search:force_create_index
script/server
```

Branta is meant to be hosted in two ways:

* There's an instance running on Heroku that's free for everyone. Enjoy!
* You can host your own instance on your own server. You'll likely want to set `GITHUB_BRANTA_ORG_NAME` to the GitHub organization you belong to. Otherwise, anyone outside your org will be able to have their pages indexed in your instance.

## Environment variables

If you're running Branta yourself, you should set the following environment variables:

|Envrionment variable | Description
|---------------------|------------
|`GITHUB_BRANTA_CLIENT_ID` | The client ID of your Branta OAuth app instance.
|`GITHUB_BRANTA_CLIENT_SECRET` | The client secret of your Branta OAuth app instance.
|`GITHUB_BRANTA_ORG_NAME` | Restricts access to Branta to just users within the `GITHUB_BRANTA_ORG_NAME` GitHub organization.
| `BRANTA_PER_PAGE_COUNT` | The number of results to return per page. Default is 25, maximum is 50.

### TODO:

- Some kind of "oh shit" reindex everything task
- Enforce requiring repo and q
- Forbid non-org indexing

[PageBuildEvent]: https://developer.github.com/v3/activity/events/types/#pagebuildevent
