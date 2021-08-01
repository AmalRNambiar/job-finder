roomId = document.querySelector('#room').getAttribute('room_id')

App.messages = App.cable.subscriptions.create({
  channel: 'JobsChannel',
  room_id: roomId
}, {
  received: function (data) {
    console.log(data)
    if (data.length > 0) {
      this.appendLine(data)
    } else {
      this.noDataFound()
    }
  },

  noDataFound() {
    const autoComplete = document.querySelector('#job_list')
    if (autoComplete) {
      const html = this.autoCompleteNoData()
      autoComplete.innerHTML = html
    } else {
      const resultPage = document.querySelector('#result_page')
      const html = this.resultPageNoData()
      resultPage.innerHTML = html
    }
  },

  autoCompleteNoData() {
    return `
      <div class=""ui active inverted dimmer">
        <div class="ui no_data_text">No records were found that match your query.</div>
      </div>
    `
  },

  resultPageNoData() {
    return `
      <div class="ui active inverted dimmer" style='min-height: 400px;'>
        <div class="ui text">No records were found that match your query.</div>
      </div>
    `
  },

  appendLine(data) {
    const autoComplete = document.querySelector('#job_list')
    if (autoComplete) {
      const html = this.autoCompleteJobList(data)
      autoComplete.innerHTML = html
    } else {
      const urlSearchParams = new URLSearchParams(window.location.search);
      const params = Object.fromEntries(urlSearchParams.entries());
      const resultPage = document.querySelector('#result_page')
      document.querySelector('#total_results').innerText = `${params.query} (${data.length} results)`
      const html = this.resultPageJobList(data)
      resultPage.innerHTML = html
    }
  },

  autoCompleteJobList(data) {
    return `
      <div class="ui relaxed divided link items">${data.map(job => this.autoCompleteJobCard(job)).join('')}</div>
    `
  },

  autoCompleteJobCard(job) {
    return `
      <a class="item" href=/jobs/${job.guid} >
        <div class="middle aligned content">
          <div class="header">${job.title}</div>
          <div class="meta">${job.author.name}</div>
        </div>
      </a>
    `
  },

  resultPageJobList(data) {
    return data.map(job => this.resultPageJobCard(job)).join('')
  },

  resultPageJobCard(job) {
    return `
      <a class="item" href=/jobs/${job.guid}>
        <div class="small image">
          <img src=${jobImage(job.title)}>
        </div>
        <div class="content">
          <div class="header">${job.title}</div>
          <div class="meta">
            <span>${job.author.name}</span>
          </div>
          <div class="description">
            <p>${extractContent(job.description)}</p>
          </div>
          <div class="extra">
            <div class="ui right floated primary button">
              View More
              <i class="right chevron icon"></i>
            </div>
            <div class="ui label"><i class="green arrow alternate circle down outline icon"></i> ${Math.floor(Math.random() * 100)} Applicants</div>
            <div class="ui label"><i class="yellow star icon"></i> ${Math.floor(Math.random() * 5)} Rating</div>
          </div>
        </div>
      </a>
    `
  },

});

function extractContent(s) {
  var span = document.createElement('span');
  span.innerHTML = s;
  text = span.textContent || span.innerText;
  return text.replace(/\n\s+/g, '').substring(0, 200);
};


function jobImage(title) {
  color = Math.floor(Math.random() * 16777215).toString(16)
  title = title.replace(/[^a-zA-Z ]/g, "").substring(0, 10)
  return `https://dummyimage.com/300x300/${color}/ffffff.png&text=${title}`
};