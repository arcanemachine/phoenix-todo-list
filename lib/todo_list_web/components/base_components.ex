defmodule TodoListWeb.BaseComponents do
  @moduledoc """
  Provides basic UI components that are accessible from any template.
  """

  use Phoenix.Component

  slot :user_action_menu_items, required: true

  def navbar(assigns) do
    ~H"""
    <nav class="navbar py-0 border-y-2 transition-colors duration-300">
      <!-- navbar start items -->
      <div class="flex-1">
        <!-- navbar title -->
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
      <!-- navbar end items -->
      <div class="mr-1 flex-none">
        <.dark_mode_toggle />
        <!-- menu - user actions -->
        <div class="dropdown-end dropdown" x-tooltip="User Actions">
          <label tabindex="0" class="btn-ghost btn-square btn m-1">
            <Heroicons.user_circle solid class="h-7 w-7 stroke-current" />
          </label>
          <ul class="dropdown-content menu rounded-box w-52 bg-base-100 p-2 shadow">
            <%= render_slot(@user_action_menu_items) %>
          </ul>
        </div>
      </div>
    </nav>
    """
  end

  def dark_mode_toggle(assigns) do
    ~H"""
    <div class="pr-2 flex" x-data="darkModeToggle" x-cloak>
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
end
