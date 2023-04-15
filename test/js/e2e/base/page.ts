import { Locator, Page } from "@playwright/test";

interface ToastContainer extends Locator {
  hasToast: Function;
}

export class BasePage {
  readonly page: Page;

  // // page elements
  // readonly flashInfo: Locator;
  // readonly flashError: Locator;
  // readonly flashDisconnected: Locator;

  // readonly navbar: Locator;
  readonly toastContainer: ToastContainer;

  constructor(page: Page) {
    this.page = page;

    // this.flashDisconnected = page.locator("#flash-disconnected");
    // this.flashError = page.locator("#flash-error");
    // this.flashInfo = page.locator("#flash-info");

    // this.navbar = page.locator("[data-component='navbar']");
    this.toastContainer = page.locator("#toast-container") as ToastContainer;
  }

  // async toastClear() {
  //   /** Clear all toast messages. */
  //   await this.page.evaluate(() => {
  //     const toastContainerElt = document.querySelector("#toast-container");
  //     toastContainerElt!.dispatchEvent(new CustomEvent("clear"));
  //   });
  // }
}
