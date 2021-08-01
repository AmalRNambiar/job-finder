import React from 'react';
import SearchResult from './SearchResult';

export default ({ results, loading, status }) => {
  return <div className="ui raised segment no padding job_list_container" key={status} id='job_list'>
    {(loading || status == 'enqueued') ? (
      <div className="ui active inverted dimmer">
        <div className="ui text loader">{status == 'enqueued' ? 'Request is being processed and results will be available shortly.' : 'Loading...'}</div>
      </div>
    ) : (
        <div className="ui relaxed divided link items">
          {results.map(result => <SearchResult key={result.id} result={result} />)}
        </div>
      )}
  </div>
}