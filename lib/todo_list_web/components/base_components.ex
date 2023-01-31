defmodule TodoListWeb.BaseComponents do
  @moduledoc """
  Provides basic UI components that are accessible from any template.
  """

  use Phoenix.Component

  attr :title, :string, default: nil
  attr :items, :list, required: true

  def action_links(assigns) do
    ~H"""
    <section class="mt-12">
      <h3 class="text-2xl font-bold">
        <%= @title || "Actions" %>
      </h3>
      <ul class="mt-2 ml-8 list-disc">
        <li :for={item <- @items} class="mt-2 pl-2">
          <.link navigate={item.href}>
            <%= item.content %>
          </.link>
        </li>
      </ul>
    </section>
    """
  end

  @doc """
  Renders a loading indicator.

  ## Example

      <.loader />
  """
  attr :class, :string, default: nil

  def loader(assigns) do
    ~H"""
    <Heroicons.arrow_path class={[
      "w-5 h-5 hidden phx-click-loading:inline phx-submit-loading:inline animate-spin",
      @class
    ]} />
    """
  end

  @doc """
  Renders a toggle for light and dark themes.

  ## Example

      <.dark_mode_toggle />
  """
  def dark_mode_toggle(assigns) do
    ~H"""
    <div class="pr-2 flex" x-data="darkModeToggle" x-cloak>
      <label
        class="flex-center mr-3 flex grid swap swap-rotate"
        x-bind:class="lightModeToggled && 'swap-active'"
      >
        <Heroicons.sun
          solid
          class="h-4 w-4 stroke-current text-warning swap-on"
          aria-label="Light Mode Icon"
        />
        <Heroicons.moon solid class="h-4 w-4 stroke-current swap-off" aria-label="Dark Mode Icon" />
      </label>
      <input
        type="checkbox"
        class="toggle transition-none"
        x-bind:class="lightModeToggled && 'toggle-warning'"
        x-model="lightModeToggled"
        x-tooltip="Toggle dark mode"
        @click="darkModeToggle"
      />
    </div>
    """
  end

  @doc """
  Renders the primary navbar.

  ## Example

      <.navbar>
        <ul>
          <li>
            <.link navigate={~p"/users/profile"}>Your profile</.link>
          </li>
        </ul>
      </.navbar>
  """
  slot :user_action_menu_items, required: true

  def navbar(assigns) do
    ~H"""
    <nav class="navbar py-0 border-y-2 transition-colors duration-300">
      <!-- navbar start items -->
      <div class="flex-1">
        <!-- navbar title -->
        <.link href="/" aria-current="page" aria-label="Homepage" class="flex-0 btn-ghost btn px-2">
          <div class="font-title inline-flex text-2xl normal-case text-primary">
            Todo List
          </div>
        </.link>
      </div>
      <!-- navbar end items -->
      <div class="mr-1 flex-none">
        <.dark_mode_toggle />
        <!-- menu - user actions -->
        <div
          class="dropdown-end dropdown"
          id="navbar-dropdown-user-actions"
          x-bind:class="show && 'dropdown-open'"
          x-data="{ show: false }"
          x-tooltip="User Actions"
          @pointerdown.outside="show = false"
        >
          <label
            tabindex="0"
            class="btn-ghost btn-square btn m-1"
            @focus="show = true"
            @blur="show = false"
            @click="show = !show"
          >
            <Heroicons.user_circle solid class="h-7 w-7 stroke-current" />
          </label>
          <ul class="dropdown-content dropdown-open menu rounded-box w-52 bg-base-100 p-2 shadow">
            <%= render_slot(@user_action_menu_items) %>
          </ul>
        </div>
      </div>
    </nav>
    """
  end
end
