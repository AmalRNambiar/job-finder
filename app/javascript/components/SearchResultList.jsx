import React from 'react';
import SearchResult from './SearchResult';
const message = {
  'enqueued': 'Request is being processed and results will be available shortly.',
  'loading': 'Loading...',
  'nodata': 'No records were found that match your query.'
}
export default ({ results, status }) => {
  return <div className="ui raised segment no padding job_list_container" key={status} >
    {(results.length == 0) ? (
      <div className="ui active inverted dimmer">
        <div className="ui text loader">{message[status]}</div>
      </div>
    ) : (
        <div className="ui relaxed divided link items">ass
          {results.map(result => <SearchResult key={result.guid} result={result} />)}
        </div>
      )}
  </div>
}