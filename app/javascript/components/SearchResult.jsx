import React from 'react';

export default ({ result }) => (
  <a className="item" href={`/jobs/${result.guid}`}>
    <div className="middle aligned content">
      <div className="header">{result.title}</div>
      <div className="meta">{result.author}</div>
    </div>
  </a>
);