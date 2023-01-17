defmodule TodoListWeb.BaseComponents do
  @moduledoc """
  Provides basic UI components that are accessible from any template.
  """
  use Phoenix.Component

  def navbar(assigns) do
    ~H"""
    <nav class="navbar py-0 border-y-2 transition-colors duration-300">
      <.navbar_start_items />
      <.navbar_end_items />
    </nav>
    """
  end

  def navbar_start_items(assigns) do
    ~H"""
    <div class="flex-1">
      <.navbar_title />
    </div>
    """
  end

  def navbar_title(assigns) do
    ~H"""
    <.link navigate="/" aria-current="page" aria-label="Homepage" class="flex-0 btn-ghost btn px-2">
      <div class="font-title inline-flex text-2xl normal-case text-primary">
        Todo List
      </div>
    </.link>
    """
  end

  def navbar_end_items(assigns) do
    ~H"""
    <div class="mr-1 flex-none">
      <.dark_mode_toggle />
      <.navbar_action_menu />
    </div>
    """
  end

  def dark_mode_toggle(assigns) do
    ~H"""
    <div class="pr-2 flex" x-data="$store.components.darkModeToggle">
      <div class="flex-center mr-3 flex grid">
        <template x-if="lightModeToggled">
          <Heroicons.sun
            solid
            class="h-4 w-4 stroke-current text-warning"
            aria-label="Light Mode Icon"
          />
        </template>
        <template x-if="!lightModeToggled">
          <Heroicons.moon solid class="h-4 w-4 stroke-current" aria-label="Dark Mode Icon" />
        </template>
      </div>
      <input
        type="checkbox"
        class="toggle"
        x-bind:class="lightModeToggled && 'toggle-warning'"
        x-model="lightModeToggled"
        x-tooltip="Toggle dark mode"
        @click="darkModeToggle"
      />
    </div>
    """
  end

  def navbar_action_menu(assigns) do
    ~H"""
    <div class="dropdown-end dropdown">
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
    """
  end
end
