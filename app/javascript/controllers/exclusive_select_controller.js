import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="exclusive-select"
export default class extends Controller {
  static targets = ["select"];

  connect() {
    const groups = this.selectTargets
      .map((target) => target.dataset.exclusiveSelectGroupParam)
      .filter((group, index, array) => array.indexOf(group) == index);
    groups.forEach((group) => {
      this.#updateSelects(group);
    });
  }

  exclusivize(event) {
    this.#updateSelects(event.params.group);
  }

  #updateSelects(group) {
    const selects = this.selectTargets.filter((target) => target.dataset.exclusiveSelectGroupParam == group);

    selects.forEach((select) => {
      Array.from(select.options).forEach((option) => {
        option.hidden = false;
      });
    });

    const selectedValues = selects.map((select) => select.value).filter((value) => value != "");

    selects.forEach((select) => {
      selectedValues.forEach((selectedValue) => {
        const option = Array.from(select.options).find((option) => option.value == selectedValue);
        if (select.value != option.value) {
          option.hidden = true;
        }
      });
    });
  }
}
