# Hey all, quick update on the state of things:

## Progress so far:

### [Business API External - Dashboard](https://intranet.justwatch.com/grafana/d/ddnckp46psfswe/b2b-external-business-api-health-and-perf?orgId=1&from=now-7d&to=now)

Variety of visualizations of metrics from the external business API. Including, but not limited to:

* Number of requests per country of origin
* Rate of requests to each different endpoint
* Dependency health
* Rate of requests coming from each of the different clients

This included the addition of the [`business_api_external_request_count`](https://intranet.justwatch.com/thanos/query/graph?g0.expr=business_api_external_request_count&g0.tab=1&g0.stacked=0&g0.range_input=1h&g0.max_source_resolution=0s&g0.deduplicate=1&g0.partial_response=0&g0.store_matches=%5B%5D) prometheus metric for us to be able to visualize how many quickly we are getting requests and by whom.

### Alerting

* Removed spammy pixel-api log based alerts: [link](https://github.com/justwatch/terraform/pull/645)
* Moved relevant alerts to `#martech-alerts`
* Routed `PodDownToZero` and `BusinessCampaignReactionsOutOfSync` alerts to the 'martech' route in incident.io

### [B2B Health & Perf - Dashboard](https://intranet.justwatch.com/grafana/d/adlo3bi4z1nggf/wip-rewrite-justwatch-b2b-health-and-perf?orgId=1)

Aim to keep what is useful (mostly hardware metrics, CPU/Memory), improve upon less actionable or unclear metrics (supplier syncs, subcampaign state over time etc) and add more actionable and relevant information.

Some preliminary work has been done, but this has a long way to go and will be a big focus from here on out.

## Next steps

### Business API External

* Measure response quality over time (potentially average of similarity score of top 5-10 audiences?)
* imdbid <-> jwid success/fail

### Alerting

* Take a closer look at what alerts can be cut to remove unnecessary noise
* Work together with 'martech' in configuring incident.io, potentially new alerts as needed.

### B2B Health & Perf

* improve upon the green tile board to give it historical data
* how many subcampaigns are created/paused/finished per day
* syncs: express as a percentage
* work with Mykola to standardize measurement units where possible
* ...and more, as requirements comes up

I think that is all for now.  Admittedly, this started off slow but I am confident that the next couple of months will be a lot smoother.  Looking forward to it!
