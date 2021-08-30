terraform {
  required_providers {
    checkly = {
      source = "checkly/checkly"
      version = "1.2.0"
    }
  }
}

provider "checkly" {
  api_key = var.checkly_api_key
}

resource "checkly_check" "check-catalogue-list" {
  name = "Check the catalogue list"
  type = "API"
  activated = true
  should_fail = false
  frequency = var.frequency
  double_check = true
  ssl_check = true
  use_global_alert_settings = true

  locations = var.locations

  request {
    url = "http://${var.inlets-exit-node-ip}/catalogue"
    follow_redirects = true
    assertion {
      source = "STATUS_CODE"
      comparison = "EQUALS"
      target = "200"
    }
  }
}

resource "checkly_check" "browser-socks-ui" {
  name = "Check UI"
  type = "BROWSER"
  activated = true
  should_fail = false
  frequency = var.frequency
  double_check = true
  ssl_check = true
  use_global_alert_settings = true

  locations = var.locations

  script = <<EOT
const assert = require("chai").assert;
const puppeteer = require("puppeteer");

const browser = await puppeteer.launch();
const page = await browser.newPage();
await page.goto("http://${var.inlets-exit-node-ip}/");
const title = await page.title();

assert.equal(title, "WeaveSocks");
await browser.close();

EOT
}