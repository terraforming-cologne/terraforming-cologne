import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="timer"
export default class extends Controller {
  static targets = ["rocket", "timer"];

  static values = {
    startTime: String,
    duration: Number,
  };

  connect() {
    this.update();
    this.interval = setInterval(this.update.bind(this), 1000);
  }

  disconnect() {
    clearInterval(this.interval);
  }

  update() {
    // Get today's date components
    const today = new Date();
    const year = today.getFullYear();
    const month = today.getMonth(); // 0-based
    const day = today.getDate();

    // Parse start time
    const [hours, minutes, seconds = 0] = this.startTimeValue.split(":").map(Number);
    let startTime = new Date(year, month, day, hours, minutes, seconds);

    // Compute end time by adding duration in seconds
    let endTime = new Date(startTime.getTime() + this.durationValue * 1000);

    // Current time
    let now = new Date();

    // Percentage of elapsed time
    let percentage = (now - startTime) / (endTime - startTime);
    percentage = Math.max(0, Math.min(1, percentage)); // clamp 0–1

    let length = 100 + 1500 * percentage;

    this.rocketTarget.style.top = "250px";
    this.rocketTarget.style.left = `${length}px`;

    console.log(endTime);
    console.log(now);
    console.log(endTime - now);
    this.timerTarget.textContent = this.formatSeconds(Math.floor((endTime - now) / 1000));
  }

  formatSeconds(seconds) {
    const hrs = Math.floor(seconds / 3600);
    const mins = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;

    // Pad with leading zeros
    const formatted = [hrs, mins, secs].map((unit) => String(unit).padStart(2, "0")).join(":");

    return formatted;
  }
}
