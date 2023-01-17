defmodule TodoListWeb.BaseComponents do
  @moduledoc """
  Provides basic UI components that are accessible from any template.
  """
  use Phoenix.Component

  def navbar(assigns) do
    ~H"""
    <nav class="navbar py-0 border-y-2 transition-colors duration-300">
      <!-- title -->
      <div class="flex-1">
        <.link
          navigate="/"
          aria-current="page"
          aria-label="Homepage"
          class="flex-0 btn-ghost btn px-2"
        >
          <div class="font-title inline-flex text-2xl normal-case text-primary">
            Todo List
          </div>
        </.link>
      </div>

      <div class="mr-1 flex-none">
        <!-- dark mode toggle
        <span class="pr-2">
          <.dark_mode_toggle />
        </span>
           -->
        <!-- action menu -->
        <.alpine_example />
        <div class="dropdown-end dropdown {$user.prefs.bottomNavbarEnabled && 'dropdown-top'}">
          <label tabindex="0" class="btn-ghost btn-square btn m-1">
            <Heroicons.user_circle solid class="h-7 w-7 stroke-current" />
          </label>
          <ul class="dropdown-content menu rounded-box w-52 bg-base-100 p-2 shadow">
            <%= if :rand.uniform(2) != 1 do %>
              <li><a href="/user/login">Login</a></li>
              <li><a href="/user/register">Register</a></li>
            <% else %>
              <li><a href="/user">Your profile</a></li>
              <li><a href="/user/logout">Logout</a></li>
            <% end %>
          </ul>
        </div>
      </div>
    </nav>
    """
  end

  def alpine_example(assigns) do
    ~H"""
    <div x-data="$store.components.helloWorld">
      <div x-text="message"></div>
    </div>
    """
  end

  def dark_mode_toggle(assigns) do
    ~H"""
    <div class="flex" x-data="alpineComponents.darkModeToggle">
      <div class="flex-center mr-2 flex grid">
        <template x-if="lightModeToggled">
          <div class="item">
            <span aria-label="Light Mode Icon">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="16"
                height="16"
                fill="currentColor"
                style="color: hsl(var(--wa))"
                class="bi bi-sun"
                viewBox="0 0 16 16"
              >
                <path d="M8 11a3 3 0 1 1 0-6 3 3 0 0 1 0 6zm0 1a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM8
                         0a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 0zm0 13a.5.5 0 0 1
                         .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 13zm8-5a.5.5 0 0 1-.5.5h-2a.5.5
                         0 0 1 0-1h2a.5.5 0 0 1 .5.5zM3 8a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2A.5.5
                         0 0 1 3 8zm10.657-5.657a.5.5 0 0 1 0 .707l-1.414 1.415a.5.5 0 1
                         1-.707-.708l1.414-1.414a.5.5 0 0 1 .707 0zm-9.193 9.193a.5.5 0 0 1 0
                         .707L3.05 13.657a.5.5 0 0 1-.707-.707l1.414-1.414a.5.5 0 0 1 .707
                         0zm9.193 2.121a.5.5 0 0 1-.707 0l-1.414-1.414a.5.5 0 0 1 .707-.707l1.414
                         1.414a.5.5 0 0 1 0 .707zM4.464 4.465a.5.5 0 0 1-.707 0L2.343 3.05a.5.5 0
                         1 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .708z" />
              </svg>
            </span>
          </div>
        </template>
        <template x-if="lightModeToggled">
          <div
            class="item"
            x-transition:enter="transition ease-out duration-300"
            x-transition:enter-start="opacity-0 scale-90"
            x-transition:enter-end="opacity-100 scale-100"
            x-transition:leave="transition ease-in duration-300"
            x-transition:leave-start="opacity-100 scale-100"
            x-transition:leave-end="opacity-0 scale-90"
          >
            <span aria-label="Dark Mode Icon">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="16"
                height="16"
                fill="currentColor"
                class="bi bi-sun"
                viewBox="0 0 16 16"
              >
                <path d="M8 11a3 3 0 1 1 0-6 3 3 0 0 1 0 6zm0 1a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM8
                         0a.5.5 0 0 1 .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 0zm0 13a.5.5 0 0 1
                         .5.5v2a.5.5 0 0 1-1 0v-2A.5.5 0 0 1 8 13zm8-5a.5.5 0 0 1-.5.5h-2a.5.5
                         0 0 1 0-1h2a.5.5 0 0 1 .5.5zM3 8a.5.5 0 0 1-.5.5h-2a.5.5 0 0 1 0-1h2A.5.5
                         0 0 1 3 8zm10.657-5.657a.5.5 0 0 1 0 .707l-1.414 1.415a.5.5 0 1
                         1-.707-.708l1.414-1.414a.5.5 0 0 1 .707 0zm-9.193 9.193a.5.5 0 0 1 0
                         .707L3.05 13.657a.5.5 0 0 1-.707-.707l1.414-1.414a.5.5 0 0 1 .707
                         0zm9.193 2.121a.5.5 0 0 1-.707 0l-1.414-1.414a.5.5 0 0 1 .707-.707l1.414
                         1.414a.5.5 0 0 1 0 .707zM4.464 4.465a.5.5 0 0 1-.707 0L2.343 3.05a.5.5 0
                         1 1 .707-.707l1.414 1.414a.5.5 0 0 1 0 .708z" />
              </svg>
            </span>
          </div>
        </template>
      </div>
      <input type="checkbox" class="toggle" x-model="lightModeToggled" @click="darkModeToggle" />
    </div>

    <style>
      .item {
        grid-column-start: 1;
        grid-column-end: 2;
        grid-row-start: 1;
        grid-row-end: 2;
      }
    </style>
    """
  end
end
