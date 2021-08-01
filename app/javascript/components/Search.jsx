import React from 'react';
import axios from 'axios';
import SearchResultList from './SearchResultList';

export default class Search extends React.Component {
  state = {
    searchKey: "",
    loading: false,
    status: "",
    results: [],
    typing: false,
    typingTimeout: 0
  };

  onChange = async (e) => {
    const self = this;

    if (self.state.typingTimeout) {
      clearTimeout(self.state.typingTimeout);
    }

    self.setState({
      searchKey: e.target.value,
      typing: false,
      loading: true,
      results: [],
      typingTimeout: setTimeout(this.search, 1500)
    });
  }

  search = async () => {
    try {
      this.setState({ loading: true });
      const { searchKey } = this.state
      if (searchKey.length > 2) {
        const res = await axios.get('/search.json', { params: { query: searchKey } })
        console.log(res.data.length)
        if (res.data.length == 0) {
          this.setState({ loading: true, results: res.data, status: 'enqueued' })
        } else {
          this.setState({ loading: false, results: res.data, status: 'from_cache' })
        }
      } else {
        if (searchKey.length == 0) {
          this.setState({ loading: false, results: [], status: 'exit' });
        } else {
          this.setState({ loading: true, results: [], status: 'waiting' });
        }
      }
    }
    catch (e) {
      this.setState({ loading: false, results: [] })
    }
  }

  render() {
    const { loading, results, status } = this.state;
    console.log(this.state)
    return (
      <div className="ui raised segment no padding">
        <form method="GET" action="search">
          <div className="ui fluid icon transparent large input">
            <input name="query" type="text" placeholder="Search jobs...(enter atleast 3 characters)" onChange={this.onChange} autoComplete="off" />
            <button type="submit">
              <i className="search icon"></i>
            </button>
          </div>
          {results.length > 0 || loading ? <SearchResultList results={results} loading={loading} status={status} /> : null}
        </form>
      </div>
    );
  }
}