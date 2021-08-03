import React from 'react';
import axios from 'axios';
import SearchResultList from './SearchResultList';

export default class Search extends React.Component {
  state = {
    searchKey: "",
    status: "idle",
    results: [],
    typing: false,
    typingTimeout: 0
  };

  componentDidMount = async () => {
    this.createWebsocketConnection('ws://localhost:3000/cable')
  };

  createWebsocketConnection = (WDS_SOCKET_PATH) => {
    let socket = new WebSocket(WDS_SOCKET_PATH);
    let self = this;
    socket.onopen = function (event) {
      const msg = {
        command: "subscribe",
        identifier: JSON.stringify({
          channel: "JobsChannel"
        })
      };
      socket.send(JSON.stringify(msg));
    };
    socket.onclose = function (event) {
      console.log("WebSocket is closed.");
    };
    socket.onmessage = function (event) {
      const response = JSON.parse(event.data);
      if (response.message && response.message.jobs) {
        self.setState({ results: response.message.jobs, status: response.message.jobs == 0 ? 'nodata' : 'completed' })
      } else if (response.type != 'ping') {
        self.setState({ results: [], status: 'idle' })
      }
    };
    socket.onerror = function (error) {
      console.log("WebSocket Error: " + error);
    };
  };

  onChange = async (e) => {

    if (this.state.typingTimeout) {
      clearTimeout(this.state.typingTimeout);
    }

    this.setState({
      searchKey: e.target.value,
      typing: false,
      status: 'loading',
      results: [],
      typingTimeout: setTimeout(this.search, 1500)
    });
  }

  search = async () => {
    try {
      this.setState({ status: "loading", results: [] });
      const { searchKey } = this.state
      if (searchKey.length > 2) {
        const res = await axios.get('/search.json', { params: { query: searchKey } })
        if (res.data.length == 0) {
          this.setState({ results: [], status: 'enqueued' })
        } else {
          this.setState({ results: res.data, status: 'completed' })
        }
      } else {
        if (searchKey.length == 0) {
          this.setState({ results: [], status: 'idle' });
        } else {
          this.setState({ results: [], status: 'loading' });
        }
      }
    }
    catch (e) {
      this.setState({ results: [], status: 'idle' })
    }
  }

  render() {
    const { results, status } = this.state;

    return (
      <div className="ui raised segment no padding">
        <form method="GET" action="search">
          <div className="ui fluid icon transparent large input">
            <input name="query" type="text" placeholder="Search jobs...(enter atleast 3 characters)" onChange={this.onChange} autoComplete="off" />
            <button type="submit">
              <i className="search icon"></i>
            </button>
          </div>
          {(status != 'idle') ? <SearchResultList results={results} status={status} /> : null}
        </form>
      </div>
    );
  }
}