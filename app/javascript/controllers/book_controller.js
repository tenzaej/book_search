import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ "query", "page" ]

  onPostSuccess(event) {
    confirm(`searching for ${this.query} on page ${this.page}`);
    let [data, status, xhr] = event.detail;
    document.getElementById('app-body').innerHTML = xhr.response;
    console.log(xhr.response);
  }

  get query() {
    return this.queryTarget.value;
  }

  get page() {
    return parseInt(this.pageTarget.value);
  }
}
